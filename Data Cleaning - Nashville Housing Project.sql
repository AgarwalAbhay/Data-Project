/* Cleaning data in SQL Queries */
SELECT *
FROM housing

/* Getting the Property Address */
SELECT *
FROM housing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM housing a
JOIN housing b 
	ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

Update housing
SET PropertyAddress = NULL
WHERE COALESCE(NULLIF(TRIM(PropertyAddress),''),'') = ''

UPDATE housing a
JOIN housing b 
	ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL

/* Breaking Address into SIngle Coloumns (Address, City, State) */
SELECT PropertyAddress
FROM housing

SELECT substring(PropertyAddress,1, LOCATE(",",PropertyAddress,1)-1) AS Address, substring(PropertyAddress, LOCATE(",",PropertyAddress,1)+2) AS City
FROM housing

ALTER TABLE housing
ADD PropertySplitAddress nvarchar(255);

UPDATE housing
SET PropertySplitAddress = substring(PropertyAddress,1, LOCATE(",",PropertyAddress,1)-1)

ALTER TABLE housing
ADD PropertySplitCity nvarchar(255);

UPDATE housing
SET PropertySplitCity = substring(PropertyAddress, LOCATE(",",PropertyAddress,1)+2)

/* Getting the Owner Names for Blank Rows */
SELECT substring(OwnerAddress, 1, LOCATE(',',OwnerAddress,1)-1) AS OwnerSplitAddress, 
	substring(OwnerAddress, LOCATE(',',OwnerAddress,1)+2,LENGTH(substring_index(OwnerAddress,',',2)) - LENGTH(substring(OwnerAddress,1,LOCATE(',',OwnerAddress,1)+1))) AS OwnerSplitCity,
	substring_index(OwnerAddress, ',',-1) AS OwnerSplitState
FROM housing

ALTER TABLE housing
ADD OwnerSplitAddress nvarchar(255);

UPDATE housing
SET OwnerSplitAddress = substring(OwnerAddress, 1, LOCATE(',',OwnerAddress,1)-1)

ALTER TABLE housing
ADD OwnerSplitCity nvarchar(255);

UPDATE housing
SET OwnerSplitCity = substring(OwnerAddress, LOCATE(',',OwnerAddress,1)+2,LENGTH(substring_index(OwnerAddress,',',2)) - LENGTH(substring(OwnerAddress,1,LOCATE(',',OwnerAddress,1)+1)))

ALTER TABLE housing
ADD OwnerSplitState nvarchar(255);

UPDATE housing
SET OwnerSplitState = substring_index(OwnerAddress, ',',-1)

SELECT *
FROM housing

/* Changing Y and N in Sold as Vacant to Yes and No */
SELECT SoldasVacant, CASE WHEN SoldasVacant = "Y" THEN "YES"
		WHEN SoldasVacant = "N" THEN "NO"
        ELSE SoldasVacant
        END
FROM housing

UPDATE housing
SET SoldasVacant = CASE WHEN SoldasVacant = "Y" THEN "YES" 
WHEN SoldasVacant = "N" THEN "NO"
ELSE SoldasVacant
END



/* Drop unused columns */
ALTER TABLE housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate