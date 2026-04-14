@AbapCatalog.sqlViewName: 'ZSALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order print'
@Metadata.ignorePropagatedAnnotations: true
//define view zsd_salesorder as select distinct from I_SalesQuotation as saleqou
//inner join  I_SalesQuotationPartner as salepart
//on saleqou.SalesQuotation = salepart.SalesQuotation and salepart.PartnerFunction = 'WE'
//
//left outer join  I_Customer as NAME
//on salepart.Customer = NAME.Customer 
//
//left outer join  I_Address_2 as add 
//on NAME.AddressID = add.AddressID
//
//
//{ key salepart.Customer as shiptoparty,
//      saleqou.SalesQuotation,
//      NAME.CustomerFullName as name ,
//      NAME.TaxNumber3 as gstnumber ,
//      add.StreetName as address 

//      add.StreetPrefixName1 as address ,
//      add.StreetPrefixName2 as address ,
//      add.CityName as address ,
//      add.PostalCode as address ,
//      add.Country as address ,
//      add.Region 
//        
    
 define view zsd_salesorder  as select from I_SalesQuotation as A
    inner join I_SalesQuotationPartner as B
      on A.SalesQuotation = B.SalesQuotation
    inner join I_Customer as C
      on B.Customer = C.Customer
    inner join I_SalesQuotationItem as H
      on A.SalesQuotation = H.SalesQuotation
    inner join I_Product as P
      on H.Product = P.Product
        inner join I_Address_2 as F
      on C.AddressID = F.AddressID
{
  key A.SalesQuotation                          as SalesQuotation,
      A.CreationDate                            as QuotationDate,
      A.PurchaseOrderByCustomer                      as CustomerRef,
      A.CustomerPurchaseOrderDate                  as CustomerRefDate,
      A.CustomerPaymentTerms                          as PaymentTerms,
      A.IncotermsClassification                 as Incoterms,
      A.IncotermsLocation1                      as IncotermsLocation,

      // Partner functions
      max(case when B.PartnerFunction = 'AG' then B.Customer end) as SoldToParty,
      max(case when B.PartnerFunction = 'WE' then B.Customer end) as ShipToParty,
      
      
        // Full Bill-To Address
      max( case when B.PartnerFunction = 'AG' 
                then concat_with_space(
                        concat_with_space(F.StreetName, F.CityName, 1),
                        concat_with_space(F.PostalCode, F.Country, 1),
                        1)
                else '' end ) as BillToFullAddress,

      // Full Ship-To Address
      max( case when B.PartnerFunction = 'WE' 
                then concat_with_space(
                        concat_with_space(F.StreetName, F.CityName, 1),
                        concat_with_space(F.PostalCode, F.Country, 1),
                        1)
                else '' end ) as ShipToFullAddress,
      
      
      C.TaxNumber3 as GST,
      
      // Item details
      H.SalesQuotationItem                      as Item,
      H.SalesQuotationItemText                    as MaterialDescription,
      H.OrderQuantity                           as Quantity,
      H.BaseUnit                                as UnitOfMeasure,
      H.NetPriceAmount                          as NetPrice
}
group by
      A.SalesQuotation,
      A.CreationDate,
      A.PurchaseOrderByCustomer ,
      A.CustomerPurchaseOrderDate ,
      A.CustomerPaymentTerms,
      A.IncotermsClassification,
      A.IncotermsLocation1,
      C.TaxNumber3 ,
      H.SalesQuotationItem,
      H.SalesQuotationItemText ,
      H.OrderQuantity,
      H.BaseUnit,
      H.NetPriceAmount
