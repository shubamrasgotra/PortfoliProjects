/*

Data Cleaning Queries in SQL

*/

select*	
from PortfolioProject.dbo.NashvilleData


--Standardize Date Format

select SaleDate, convert(Date,SaleDate) SaleDateConverted
from PortfolioProject..NashvilleData

Update PortfolioProject.dbo.NashvilleData
Set SaleDate = convert(date,SaleDate)

--Alternate Query to alter the data columns permanently(This comes into play if the above written query doesn't work)


Alter table NashvilleData
add SaleDateConverted date

Update NashvilleData
set SaleDateConverted = CONVERT(date,SaleDate)

select SaleDateConverted
from NashvilleData

--Populate Property Address data


select *
from PortfolioProject.dbo.NashvilleData
--where PropertyAddress is null
order by ParcelID


Select og.ParcelID,og.PropertyAddress,al.ParcelID,al.PropertyAddress, ISNULL(og.PropertyAddress,al.PropertyAddress)
from PortfolioProject.dbo.NashvilleData og
join PortfolioProject.dbo.NashvilleData al
on og.ParcelID=al.ParcelID
and og.[UniqueID ]<>al.[UniqueID ]
where og.PropertyAddress is null

--Replacing the Propertyaddress as Null values with the Propertyaddress with values

update og
set PropertyAddress = ISNULL(og.PropertyAddress,al.PropertyAddress)
from PortfolioProject.dbo.NashvilleData og
join PortfolioProject.dbo.NashvilleData al
on og.ParcelID=al.ParcelID
and og.[UniqueID ]<>al.[UniqueID ]

--Breaking out Address into Individual columns (Address,State,City)
select PropertyAddress
from PortfolioProject.dbo.NashvilleData

Select	
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress))
from PortfolioProject.dbo.NashvilleData

--to remove the comma

Select	
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address1,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address2
from PortfolioProject.dbo.NashvilleData

--To add the split address columns permanently in the table
Alter table NashvilleData
add PropertySplitAddress nvarchar(255)

Update NashvilleData
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleData
add PropertySplitCity nvarchar(255)

Update NashvilleData
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select*
from NashvilleData

--Breaking out OwnerAdress into Address,city and state

select OwnerAddress
From PortfolioProject..NashvilleData

--Using Parse function instead of SUBSTRING
select
PARSENAME(REPLACE(OwnerAddress,  ',',  '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleData

Alter table NashvilleData
add OwnerSplitAddress nvarchar(255)

Update NashvilleData
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,  ',',  '.'), 3)

Alter table NashvilleData
add OwnerSplitCity nvarchar(255)

Update NashvilleData
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table NashvilleData
add OwnerSplitState nvarchar(255)
Update NashvilleData
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



select*
From NashvilleData

--Change 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant Field

Select SoldAsVacant
from NashvilleData

select distinct(SoldAsVacant),Count(SoldAsVacant)
from PortfolioProject..NashvilleData
group by SoldAsVacant
order by 2


Select SoldAsVacant,
case when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else 
SoldAsVacant
end
from PortfolioProject..NashvilleData

Update NashvilleData
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else 
SoldAsVacant
end


--Remove Duplicates
Select*
from PortfolioProject.dbo.NashvilleData

--Make a CTE first and use a query ti find out if there are any rows with same content using row_num >1 and then delete them
WITH RowNumCte as( 
select *,
  ROW_NUMBER() over(
    Partition By ParcelID,
	PropertyAddress,SalePrice,SaleDate,LegalReference
	order by UniqueID) AS row_num

	from PortfolioProject.DBO.NashvilleData
	)
	Select *
From RowNumCTE
WHERE row_num > 1
order by PropertyAddress
-- Now delete these 104 duplicate values using the same temp table
WITH RowNumCte as( 
select *,
  ROW_NUMBER() over(
    Partition By ParcelID,
	PropertyAddress,SalePrice,SaleDate,LegalReference
	order by UniqueID) AS row_num

	from PortfolioProject.DBO.NashvilleData
	)
	Delete
From RowNumCTE
WHERE row_num > 1






--Delete Unused rows 
select*
from PortfolioProject.dbo.NashvilleData

Alter table NashvilleData
drop column PropertyAddress,OwnerAddress,TaxDistrict,SaleDate

















	         











































