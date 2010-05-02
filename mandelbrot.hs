import System.Environment
import Text.Printf
import Data.Complex
import Data.List
import Char


-- Frage1: Wie debuggt man eig in Funktionen, wenn man Ausgaben nur umst�ndlich �ber Monaden machen kann?

transform ::  Int -> Int -> (Int,Int) -> (Float,Float)
transform w h (x, y) = (x',y')
                       where x' = (( 3.0 / fromIntegral w) * fromIntegral x) - 2.0
                             y' = (( 2.0 / fromIntegral h) * fromIntegral y) - 1.0


pointCheck :: (Float, Float) -> Int
pointCheck (x,y) = do let a = (x :+ y)
                      let iters = iterate (\z -> z^2 + a) a 
                      let b = (iters !! 20) 
                      fromEnum (magnitude(b)<2)

appendPixel :: String -> Int -> IO ()
appendPixel s i = appendFile s ( (show i) ++" ")

-- converts an int list to a string with whitespaces between each entry
--stringify :: [Int] -> String
--stringify [x] = (show x) ++ " "
--stringify (x:xs) = (show x) ++ " " ++ stringify xs

stringify :: [Int] -> String
stringify x = do let chl = concat $ map show x
                 intersperse ' ' chl
                 

write :: PPM -> IO()
write p = do let headStr = printf "P1\n# %s\n%d %d\n" (pName p) (pWidth p) (pHeight p) :: String
            -- let mStr = map intToDigit $ pImage p
             --print headStr
             writeFile (pName p) headStr
             appendFile (pName p) (stringify (pImage p))
             --print $ stringify (pImage p)
            -- putStr mStr
             return ()

-- data Image = Array (Integer, Integer)

data PPM = PPM {
    pWidth :: Int,
    pHeight :: Int,
    pName :: String,
    pImage :: [Int]
    }


main :: IO ()
main = do args <- getArgs
          let width = read(args !! 0) :: Int
          let height = read(args !! 1) :: Int
          let filename = args !! 2
          putStrLn "Init points "
          let points = [(x,y) | x<- [1..width], y <-[1..height]]
          putStrLn "Transforming points "
          let mpoints = map (transform width height) points
          putStrLn "Calculating pixels "
          --print  $ mpoints !! 0
          let mbrot = map pointCheck mpoints
          putStrLn "Writing file "
          --print mbrot
          let mfile = PPM {
                      pWidth = width,
                      pHeight = height,
                      pName = filename,
                      pImage = mbrot
                      }
          write mfile

          return ()