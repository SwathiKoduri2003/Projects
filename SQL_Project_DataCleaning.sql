--1
Select SaleDate
From PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing 
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = convert(date,SaleDate)

Select SaleDateConverted
From PortfolioProject.dbo.NashvilleHousing

--2

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
   On a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.propertyaddress,b.propertyaddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
   On a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

--3
select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, Len(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing 
Add PropertySplitAddress nvarchar(200)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1 )

Alter table PortfolioProject.dbo.NashvilleHousing 
Add PropertySplitCity nvarchar(200)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, Len(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

--4

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(200);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(200);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(200);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortfolioProject.dbo.NashvilleHousing

--5
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant

--6
CREATE TABLE #Table (
    ParcelID INT,
    SalePrice DECIMAL,
    UniqueID INT
)

INSERT INTO #Table (ParcelID, SalePrice, UniqueID)
SELECT ParcelID, SalePrice, MIN(UniqueID) AS MinID
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY ParcelID, SalePrice

DELETE FROM PortfolioProject.dbo.NashvilleHousing
WHERE UniqueID NOT IN (SELECT UniqueID FROM #Table)

DROP TABLE IF EXISTS #Table

--7
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN TaxDistrict

Select *
From PortfolioProject.dbo.NashvilleHousing