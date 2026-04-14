@AbapCatalog.sqlViewName: 'ZSD_SO_F'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order f4'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_so_f4 as select from I_SalesDocument as a
left outer join I_Customer as b on (  a.SoldToParty = b.Customer )

{
    key a.SalesDocument,
           a.CreationDate,
       a.SoldToParty,
       b.BPCustomerFullName
    
}

where a.SalesDocumentType = 'TA'
