{-# LANGUAGE OverloadedStrings #-}
module Main where


import Lib 
import System.Process
import System.IO
import Text.Regex.Posix
import qualified Data.Text as T

pattern = "([0-9][0-9])" :: String 

extractTemp :: String -> String
-- get 9-th line
-- from 9-th line extract the first 2 digits that appear using regex
extractTemp raw = lines raw !! 9 =~ pattern :: String



main :: IO () 
main = do 
          putStrLn "Starting service..."
          rawtemp <- readProcess "nvidia-smi" ["-q","-d","temperature"] []
          let temp = read $ extractTemp rawtemp :: Int
          rawtime <- readProcess "date" ["+%H:%M"] []
          insertOnTable (T.pack $ init rawtime) temp
          putStrLn "Finished Job" 


