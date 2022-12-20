/*
Cleaning Data in SQL quries
*/
SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

--Standardized Date Format

SELECT SaleDate
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN SaleDateConverted

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

--Populate Property Address Data
SELECT * 
FROM PortfolioProjects.dbo.NashvilleHousing
WHERE PropertyAddress is not null
ORDER BY ParcelID

SELECT * 
FROM PortfolioProjects.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing
WHERE PropertyAddress is null

--Breaking PropertyAddress into individual Address(Address, City, State)
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertSplitAddress nvarchar(255),
	PropertySplitCity nvarchar(255)

UPDATE PortfolioProjects.dbo.NashvilleHousing
SET PropertSplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1), 
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashVilleHousing
DROP COLUMN PropertyAddress

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

-- Spliting OwnerAddress
SELECT OwnerAddress
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255),
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255)

UPDATE PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT * 
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress

SELECT * 
FROM PortfolioProjects.dbo.NashvilleHousing

--Changing in SoldAsVacant
SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 1

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE
	SoldAsVacant
END
FROM PortfolioProjects.dbo.NashvilleHousing

UPDATE PortfolioProjects.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE
	SoldAsVacant
END

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

--Removing Duplicates

WITH RowNumCTE AS(
SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					PropertSplitAddress,
					PropertySplitCity,
					SalePrice,
					SaleDateConverted,
					LegalReference 
					ORDER BY 
						UniqueID
						) row_num

FROM PortfolioProjects.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertSplitAddress

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

--Deleting Unused Columns
ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN TaxDistrict

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing