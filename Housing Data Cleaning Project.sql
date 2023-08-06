SELECT * 
FROM PortflioProject..Sheet1$

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT SalesDateConverted,CONVERT(date,SaleDate) 
FROM PortflioProject..Sheet1$

alter table Sheet1$ 
add SalesDateConverted date;

update PortflioProject..Sheet1$ 
set SalesDateConverted=CONVERT(date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data



select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from PortflioProject..Sheet1$ a
join PortflioProject..Sheet1$ b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
--where a.PropertyAddress is null

update a 
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortflioProject..Sheet1$ a
join PortflioProject..Sheet1$ b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)



select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortflioProject..Sheet1$


alter table Sheet1$ 
add PropertySplitAddress nvarchar(255);

update PortflioProject..Sheet1$ 
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table Sheet1$ 
add PropertySplitCity nvarchar(255);

update PortflioProject..Sheet1$ 
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select PropertySplitAddress,PropertySplitCity
from PortflioProject..Sheet1$






Select OwnerAddress
From PortflioProject..Sheet1$


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortflioProject..Sheet1$


ALTER TABLE PortflioProject..Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update PortflioProject..Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortflioProject..Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update PortflioProject..Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortflioProject..Sheet1$
Add OwnerSplitState Nvarchar(255);

Update PortflioProject..Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
From PortflioProject..Sheet1$




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field




select SoldAsVacant,COUNT(SoldAsVacant)
from PortflioProject..Sheet1$
group by SoldAsVacant
order by 2



select SoldAsVacant,
case when SoldAsVacant='N' then 'No'
	 when SoldAsVacant='Y' then 'Yes'
	 else SoldAsVacant
	 end
from PortflioProject..Sheet1$



update PortflioProject..Sheet1$
set SoldAsVacant = case when SoldAsVacant='N' then 'No'
	 when SoldAsVacant='Y' then 'Yes'
	 else SoldAsVacant
	 end





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortflioProject..Sheet1$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortflioProject..Sheet1$




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortflioProject..Sheet1$


ALTER TABLE PortflioProject..Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
