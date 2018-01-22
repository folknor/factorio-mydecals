-- READ ME
-- when a line in this file starts with -- that means you can write whatever you want on it
-- below you can add how many decals you want.
--
-- 1. every line MUST start with data.zdecals.add(" and end with ")
-- 2. the image MUST be 256x256 size
-- 3. the image can have as many colors as you want
-- 4. data.zdecals.add("__customdecals__/decal.png") means the icon MUST BE named "decal-icon.png"
-- 5. you can do data.zdecals.add("__customdecals__/decal.png", "__customdecals__/lulzicon.png")
--    so that the icon can have any name you want
-- 6. the icon MUST be 32x32 pixels big
--
-- You can use the same icon for how ever many decals you want, it is only shown
-- on the decal print in the book, and in the signals on a combinator.
--
-- If you dont want to make an icon for your decal, write it like this
-- data.zdecals.add("__customdecals__/decal.png", false)
-- This will set the icon to a ? (questionmark) symbol.
--
-- Allowed characters in the file names are: a-z A-Z 0-9 and _-
-- Try not to use a space, but it should be fine.

if data.zdecals and data.zdecals.add then
-- ADD BELOW HERE

data.zdecals.add("__customdecals__/decal.png")

--data.zdecals.add("__customdecals__/decal.png", "__customdecals__/icon.png")
-- ADD ABOVE HERE

end
