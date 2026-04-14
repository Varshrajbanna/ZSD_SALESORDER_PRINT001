@AbapCatalog.sqlViewName: 'ZSD_QUOTATION_F'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'quotation f4'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_quotation_f4 as select from I_SalesQuotation as a
left outer join I_Customer as b on (  a.SoldToParty = b.Customer )
{
   key a.SalesQuotation,
       a.CreationDate,
       a.SoldToParty,
       b.BPCustomerFullName,
       a.SalesDocApprovalStatus,
     case when   a.DistributionChannel = '13' then '12' else a.DistributionChannel end as DistributionChannel
}
