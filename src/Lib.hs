{-# LANGUAGE OverloadedStrings #-}

module Lib  where


import           Control.Applicative
import qualified Data.Text as T
import           Database.SQLite.Simple
import           Database.SQLite.Simple.FromRow

data TestField = TestField  T.Text Int deriving (Show)

instance FromRow TestField where
  fromRow = TestField <$> field <*> field

instance ToRow TestField where
  toRow (TestField str temp) = toRow (str,temp)

insertOnTable :: T.Text -> Int -> IO ()
insertOnTable hour temp = do
  conn <- open "gpu.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS temps (hour TEXT PRIMARY KEY, temp INTEGER)"
  execute conn "INSERT OR REPLACE INTO temps (hour, temp) VALUES (?,?)" (TestField hour temp)
  r <- query_ conn "SELECT * from temps" :: IO [TestField]
  close conn
