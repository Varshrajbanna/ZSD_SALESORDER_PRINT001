CLASS zsd_price_approval_print DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS :
      read_posts
        IMPORTING
                  martdoc         TYPE i_deliverydocumentitem-deliverydocument
                  year            TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .
  PRIVATE SECTION.
    CLASS-DATA: lv_xml TYPE string.
    CLASS-DATA: lv_xml2 TYPE string.
ENDCLASS.



CLASS ZSD_PRICE_APPROVAL_PRINT IMPLEMENTATION.


  METHOD read_posts.

    DATA: lv_xml       TYPE string,
          lv_xml1      TYPE string,
          lv_xml2      TYPE string,
          lv_xml3      TYPE string,
          lv_xml4      TYPE string,
          lv_xml5      TYPE string,
          lv_xml6      TYPE string,
          invdt        TYPE string,
          add1         TYPE string,
          add2         TYPE string,
          add3         TYPE string,
          add4         TYPE string,
          add5         TYPE string,
          add6         TYPE string,
          WESITE       TYPE string,
          cin          TYPE string,
          pan          TYPE string,
          gstin        TYPE string,
          msme         TYPE string,
          lv_address   TYPE string,
          lv_address1  TYPE string,
          Valid_From TYPE string,
          lv_quatation TYPE string,
          lv_sono      TYPE string,
          lv_pono      TYPE string,
          lv_date      TYPE char10,
          lv_dateSV1   TYPE char10,
          lv_dateSV2   TYPE char10,
          lv_date1     TYPE char10,
          lv_date2     TYPE char10,
          lvpptterms   TYPE char24,
          lv_dterms    TYPE char24,
          n            TYPE char3,
          lv_tot_qty   TYPE i_salesdocumentitem-orderquantity,
          lv_tot_net   TYPE i_salesdocitempricingelement-conditionratevalue,
          lv_frieght   TYPE i_salesdocitempricingelement-conditionbaseamount,
          lv_tot_amt   TYPE i_salesdocitempricingelement-conditionbasevalue,
          lv_sale_off  TYPE string.

    TYPES: BEGIN OF ty_final,
             sno          TYPE char10,
             ServiceDocument TYPE i_salesdocumentitem-ServiceDocument,
             ServiceDocumentItem TYPE i_salesdocumentitem-ServiceDocumentItem,
             materialcode TYPE i_salesdocumentitem-product,
             materialdesc TYPE i_salesdocumentitem-salesdocumentitemtext,
             hsncode      TYPE i_productplantbasic-consumptiontaxctrlcode,
             quantity     TYPE i_salesdocumentitem-orderquantity,
             uom          TYPE i_salesdocumentitem-baseunit,
             netprice     TYPE i_salesdocitempricingelement-conditionratevalue,
             discount     TYPE i_salesdocitempricingelement-conditionratevalue,
             netvalue     TYPE i_salesdocitempricingelement-conditionratevalue,
             CONDITIONRATEAMOUNT TYPE I_SALESQUOTATIONITEMPRCGELMNT-ConditionRateAmount,
             DIFFERENTIALamount TYPE I_SALESQUOTATIONITEMPRCGELMNT-ConditionRateAmount,

           END   OF ty_final.
    DATA: it_final TYPE TABLE OF ty_final,
          wa_final TYPE          ty_final.


    SELECT SINGLE plant,DistributionChannel  FROM i_salesquotationitem WHERE salesquotation = @martdoc
          INTO @DATA(lv_plant).


    """"""""""Address
    msme = 'MSME/UDYAM-RJ-17-0509070 (Medium)'.
    add5 = 'Email:- jaipur@poddarpigmentsltd.com'.
    add6 =  'TEL NO: 0911412770202, 2770203, 2770287'.
    WESITE = 'Website – www.poddarpigmentsltd.com'.
    IF     lv_plant-Plant = '1000'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = 'PIN CODE - 302022 (RAJASTHAN) INDIA'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E2ZY'.

    ELSEIF lv_plant-Plant = '1100'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = 'PIN CODE - 302022 (RAJASTHAN) INDIA'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant-Plant = '1110'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: Greater Sitapura Industrial Park, National Highway 12' .
      add4 = '(Jaipur-Tonk Road), Brijpura village,Chaksu Jaipur 303901'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant-Plant = '1200'.
      add1 = 'PODDAR PIGMENTS LIMITED'.
      add2 = '(REGISTERED WITH ISO 9001:2015-CERTIFICATE NO. FM 53726)'.
      add3 = 'REGD OFFICE & WORKS: Rosy Tower, 3rd Floor 8, Mahatma Gandhi Road, Nungambakkam' .
      add4 = ' Chennai 600034'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '33AAACP1125E3Z4'.
    ENDIF.

    """"""""""""""Sold To Party
    SELECT SINGLE customer FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'WE'
           INTO @DATA(lv_customer).

    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'AG'
           INTO @DATA(lv_shipmob).
    IF lv_customer IS NOT INITIAL.
      SELECT SINGLE bpcustomerfullname,
                    taxnumber3,
                    addressid FROM i_customer WHERE customer = @lv_customer
               INTO @DATA(lv_cust_name).
      SELECT SINGLE bpidentificationnumber FROM i_bupaidentification WHERE bpidentificationtype = 'PAN'
                                                                     AND  businesspartner = @lv_customer
               INTO @DATA(lv_pan1).
      SELECT SINGLE streetname,
      streetprefixname1,
      streetprefixname2,
      streetsuffixname1,
      streetsuffixname2,
      cityname,
      postalcode,
      region, country   FROM i_address_2 WITH PRIVILEGED ACCESS WHERE addressid = @lv_cust_name-addressid
          INTO @DATA(lv_add).
      SELECT SINGLE regionname FROM  i_regiontext  WHERE region = @lv_add-region
                                            AND   language = 'E' AND country = @lv_add-country
                                            INTO @DATA(lv_regionname) .
      SELECT SINGLE countryname FROM i_countrytext WHERE country = @lv_add-country AND language = 'E'
                                        INTO @DATA(lv_countryname)  .
      CONCATENATE lv_cust_name-bpcustomerfullname
         lv_add-streetname lv_add-streetprefixname1 lv_add-streetprefixname2 lv_add-streetsuffixname2
       lv_add-cityname "lv_add-postalcode
         lv_regionname lv_countryname INTO lv_address SEPARATED BY space.
    ENDIF.
    """"""""""""'Ship to party
    SELECT SINGLE customer FROM  i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'RE'
               INTO @DATA(lv_customer1).
    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'WE'
           INTO @DATA(lv_soldmob).
    IF lv_customer1 IS NOT INITIAL.
      SELECT SINGLE bpcustomerfullname,
                    taxnumber3,
                    addressid FROM i_customer WHERE customer = @lv_customer1
               INTO @DATA(lv_cust_name1).
      SELECT SINGLE bpidentificationnumber FROM i_bupaidentification WHERE bpidentificationtype = 'PAN'
                                                                     AND  businesspartner = @lv_customer1
               INTO @DATA(lv_pan2).
      SELECT SINGLE streetname,
      streetprefixname1,
      streetprefixname2,
      streetsuffixname1,
      streetsuffixname2,
      cityname,
      postalcode,
      region, country   FROM i_address_2 WITH PRIVILEGED ACCESS WHERE addressid = @lv_cust_name1-addressid
          INTO @DATA(lv_add1).
      SELECT SINGLE regionname FROM  i_regiontext  WHERE region = @lv_add1-region
                                            AND   language = 'E' AND country = @lv_add1-country
                                            INTO @DATA(lv_regionname1) .
      SELECT SINGLE countryname FROM i_countrytext WHERE country = @lv_add1-country AND language = 'E'
                                        INTO @DATA(lv_countryname1)  .
      CONCATENATE lv_cust_name1-bpcustomerfullname
         lv_add1-streetname lv_add1-streetprefixname1 lv_add1-streetprefixname2 lv_add1-streetsuffixname2
       lv_add1-cityname "lv_add1-postalcode
         lv_regionname1 lv_countryname1 INTO lv_address1 SEPARATED BY space.
    ENDIF.

    """"""""""Quotation No. / Date
    SELECT SINGLE salesquotation, creationdate, TransactionCurrency ,BINDINGPERIODVALIDITYSTARTDATE ,BINDINGPERIODVALIDITYENDDATE FROM i_salesquotation
         WHERE salesquotation = @martdoc INTO @DATA(lv_prece)  .
    IF lv_prece IS NOT INITIAL.

      CONCATENATE lv_prece-creationdate+6(2) '-' lv_prece-creationdate+4(2) '-' lv_prece-creationdate+0(4)
      INTO lv_date.
      CONCATENATE lv_prece-salesquotation '/' lv_date INTO lv_quatation SEPARATED BY space.

    ENDIF.

******************************************
    IF lv_prece IS NOT INITIAL.

     CONCATENATE lv_prece-BINDINGPERIODVALIDITYSTARTDATE+6(2) '-' lv_prece-BINDINGPERIODVALIDITYSTARTDATE+4(2) '-' lv_prece-BINDINGPERIODVALIDITYSTARTDATE+0(4) INTO lv_dateSV1.
     CONCATENATE lv_prece-BINDINGPERIODVALIDITYENDDATE+6(2) '-' lv_prece-BINDINGPERIODVALIDITYENDDATE+4(2) '-' lv_prece-BINDINGPERIODVALIDITYENDDATE+0(4)   INTO lv_dateSV2.
      CONCATENATE  lv_dateSV1 'TO' lv_dateSV2 INTO Valid_From SEPARATED BY space.

    ENDIF.



******************************************






    """""""sales order No Date
    SELECT SINGLE salesquotation, creationdate, purchaseorderbycustomer,
                  customerpurchaseorderdate,
                  customerpaymentterms,
                  incotermsclassification,
                  incotermslocation1 FROM i_salesquotation
    WHERE salesquotation = @martdoc INTO @DATA(lv_document).
    IF lv_document IS NOT INITIAL.
      CONCATENATE lv_document-creationdate+6(2) '-' lv_document-creationdate+4(2) '-' lv_document-creationdate+0(4)
               INTO lv_date1.
*      CONCATENATE lv_document-salesdocument '/' lv_date1 INTO lv_sono SEPARATED BY space.

      """""""'Po No ANd Date
      CONCATENATE lv_document-customerpurchaseorderdate+6(2) '-' lv_document-customerpurchaseorderdate+4(2) '-' lv_document-customerpurchaseorderdate+0(4)
                 INTO lv_date2.
      CONCATENATE lv_document-purchaseorderbycustomer '/' lv_date2 INTO lv_pono SEPARATED BY space.

      """"""""Payment Terms
      SELECT SINGLE paymenttermsname FROM i_paymenttermstext WHERE paymentterms = @lv_document-customerpaymentterms
                                 INTO @lvpptterms.
      """"""""""Delivery terms
      CONCATENATE lv_document-incotermsclassification '-' lv_document-incotermslocation1 INTO lv_dterms.

      """"""""""""Dealer
      SELECT SINGLE customer FROM i_salesquotationpartner WHERE salesquotation = @martdoc AND partnerfunction = 'ZD'
                                     INTO @DATA(lv_cust) .
      IF lv_cust IS NOT INITIAL.
        SELECT SINGLE bpcustomerfullname   FROM i_customer WHERE customer = @lv_cust
                                       INTO @DATA(lv_bpcusname).
      ENDIF.
    ENDIF.


    """"""""""""""""'For Table Data
    SELECT
          a~product,
          a~salesquotationitemtext,
          a~salesquotationitem,
          a~salesquotation,
          a~orderquantity,
          a~baseunit,
          b~consumptiontaxctrlcode
               FROM i_salesquotationitem AS a
               LEFT OUTER JOIN i_productplantbasic AS b ON ( b~product = a~product AND b~Plant = a~Plant )
                WHERE salesquotation = @martdoc
               INTO TABLE @DATA(it_doc).

*DELETE ADJACENT DUPLICATES FROM it_doc COMPARING Product.
    IF it_doc IS NOT INITIAL.

      """""""""Net Value
      SELECT

                salesquotationitem,
                salesquotation,
                conditionratevalue
                FROM i_salesquotationitemprcgelmnt
                FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                           AND   salesquotationitem = @it_doc-salesquotationitem
                                           AND   conditiontype = 'ZPRI'
                 INTO TABLE @DATA(it_netvalue).

      """""""""""Discount
      SELECT

               salesquotationitem,
               salesquotation,
               conditionratevalue
               FROM i_salesquotationitemprcgelmnt
               FOR ALL ENTRIES IN @it_doc WHERE  salesquotation = @it_doc-salesquotation
                                          AND   salesquotationitem  = @it_doc-salesquotationitem
                                          AND   conditiontype IN ( 'ZDPQ', 'ZDCH' )
                INTO TABLE @DATA(it_discount).

"""""""""""""""" Price kgs

SELECT

                salesquotationitem,
                salesquotation,
                CONDITIONRATEAMOUNT
                FROM i_salesquotationitemprcgelmnt
                FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                           AND   salesquotationitem = @it_doc-salesquotationitem
                                           AND   conditiontype = 'ZR01'
                 INTO TABLE @DATA(pricekgs).

       """"""""""""""""""""DIFFERENTIAL AIR FREIGHT

       SELECT

                salesquotationitem,
                salesquotation,
                CONDITIONRATEAMOUNT
                FROM i_salesquotationitemprcgelmnt
                FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                           AND   salesquotationitem = @it_doc-salesquotationitem
                                           AND   conditiontype = 'ZFRT'
                 INTO TABLE @DATA(DIFFERENTIAL).

      """"""""""""""Freight Charges

      SELECT

             salesquotationitem,
              salesquotation,
              conditionamount
             FROM i_salesquotationitemprcgelmnt
              FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                         AND   salesquotationitem  = @it_doc-salesquotationitem
                                         AND   conditiontype = 'ZFPW'
               INTO TABLE @DATA(it_frieght).

      SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @martdoc
                                                                           AND ConditionType = 'ZFPW' INTO @DATA(frtcharg).

      SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @martdoc
                                                                           AND ConditionType = 'ZGIV' INTO @DATA(GT_VALUE).



      """"""""""""TOTAL TAXABLE AMOUNT
      SELECT

             salesquotationitem,
             salesquotation,
             conditionbaseamount
            FROM i_salesquotationitemprcgelmnt
             FOR ALL ENTRIES IN @it_doc WHERE salesquotation = @it_doc-salesquotation
                                         AND   salesquotationitem  = @it_doc-salesquotationitem
                                        AND   conditiontype = 'ZTIV'
              INTO TABLE @DATA(it_tot).

      """""""""""

      SELECT
            SINGLE salesoffice FROM I_SalesQuotation WHERE SalesQuotation = @martdoc
            INTO @DATA(lv_salesoffice).
      IF lv_salesoffice IS NOT INITIAL.
        SELECT SINGLE salesofficename FROM i_salesofficetext WHERE salesoffice = @lv_salesoffice AND language = 'E'
             INTO @DATA(lv_salesofficename).
        CONCATENATE ':'  lv_salesofficename INTO lv_sale_off SEPARATED BY space.
      ENDIF.






      LOOP AT it_doc INTO DATA(wa_doc).


        wa_final-servicedocument = wa_doc-SalesQuotation.
        wa_final-servicedocumentitem = wa_doc-SalesQuotationItem.
        n = n + 1.
        wa_final-sno = n.
        CONDENSE wa_final-sno.
        wa_final-materialcode = wa_doc-product.
        wa_final-materialdesc = wa_doc-SalesQuotationItemText.
        wa_final-hsncode = wa_doc-consumptiontaxctrlcode.
        wa_final-quantity = wa_doc-orderquantity.
        wa_final-uom     = wa_doc-baseunit.

        READ TABLE it_netvalue INTO DATA(wa_netvalue) WITH KEY SalesQuotation = wa_doc-SalesQuotation
                                                               SalesQuotationItem = wa_doc-SalesQuotationItem.
        IF sy-subrc = 0.
          wa_final-netprice = wa_netvalue-conditionratevalue.
        ENDIF.

        READ TABLE pricekgs INTO DATA(wa_pricekgs) WITH KEY SalesQuotation = wa_doc-SalesQuotation
                                                               SalesQuotationItem = wa_doc-SalesQuotationItem.
        IF sy-subrc = 0.
          wa_final-conditionrateamount = wa_pricekgs-ConditionRateAmount.
        ENDIF.

        READ TABLE DIFFERENTIAL INTO DATA(wa_DIFFERENTIAL) WITH KEY SalesQuotation = wa_doc-SalesQuotation
                                                               SalesQuotationItem = wa_doc-SalesQuotationItem.
        IF sy-subrc = 0.
          wa_final-differentialamount = wa_DIFFERENTIAL-ConditionRateAmount.
        ENDIF.

        LOOP AT it_discount INTO DATA(wa_discount) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          wa_final-discount = wa_final-discount + wa_discount-conditionratevalue.
        ENDLOOP.

        IF wa_final-discount < 0.
          wa_final-discount = wa_final-discount * -1.
        ENDIF.
        wa_final-netvalue = wa_final-netprice - wa_final-discount.

        lv_tot_qty = lv_tot_qty + wa_final-quantity.
        lv_tot_net = lv_tot_net + wa_final-netvalue.

        LOOP AT it_frieght INTO DATA(wa_frieght) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          lv_frieght = lv_frieght + wa_frieght-conditionamount.
        ENDLOOP.


        LOOP AT it_tot INTO DATA(wa_tot) WHERE SalesQuotation = wa_doc-SalesQuotation AND SalesQuotationItem = wa_doc-SalesQuotationItem.

          lv_tot_amt = lv_tot_amt + wa_tot-conditionbaseamount.
        ENDLOOP.



        APPEND wa_final TO it_final.

        CLEAR: wa_final.

      ENDLOOP.

    ENDIF.







    lv_xml =


|<form1> | &&
|<Quotation> | &&
|<QuotationNo>{ lv_quatation }</QuotationNo>  | &&
|<SalesOffice>{ lv_sale_off }</SalesOffice>| &&
|<CustomerName>: { lv_cust_name-BPCustomerFullName }</CustomerName> | &&
|<ValidFromValidToDate>{ Valid_From }</ValidFromValidToDate> | &&
|</Quotation>   | &&
|<Table1>    | &&
|<HeaderRow/>  | .






    LOOP AT it_final INTO wa_final.



          SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZPRI' INTO @DATA(ZPRI).


          SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZDPQ' INTO @DATA(ZDPQ).


         SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND (   ConditionType = 'ZDCM' or ConditionType = 'ZDCC'  )
                                                                           and ( ConditionInactiveReason   <> 'X'
                                                                               and ConditionInactiveReason <> 'M'
                                                                               and ConditionInactiveReason <> 'A'
                                                                               and ConditionInactiveReason <> 'T'
                                                                               and ConditionInactiveReason <> 'K'
                                                                               and ConditionInactiveReason <> 'Y' ) INTO @DATA(ZDCM).

        SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZADC' INTO @DATA(ZADC).

        SELECT sum( CONDITIONAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZDCH' INTO @DATA(ZDCH).



      SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZMOU' INTO @DATA(ZMOU).

      SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
                                                                           AND ConditionType = 'ZFCP' INTO @DATA(ZFCP).

*     SELECT sum( CONDITIONRATEAMOUNT ) FROM I_SalesQuotationItemPrcgElmnt WHERE SalesQuotation = @wa_final-servicedocument
*                                                                           AND  SalesQuotationItem = @wa_final-servicedocumentitem
*                                                                           AND ConditionType = 'ZADC' INTO @DATA(ZADC).




        IF ZDPQ < 0.
          ZDPQ = ZDPQ * -1.
        ENDIF.

        IF ZDCM < 0.
          ZDCM = ZDCM * -1.
        ENDIF.


        IF ZADC < 0.
          ZADC = ZADC * -1.
        ENDIF.


        IF ZDCH < 0.
          ZDCH = ZDCH * -1.
        ENDIF.

        IF ZFCP < 0.
          ZFCP = ZFCP * -1.
        ENDIF.




        IF ZMOU < 0.
          ZMOU = ZMOU * -1.
        ENDIF.


        IF ZADC < 0.
          ZADC = ZADC * -1.
        ENDIF.

        DATA Net_Basic TYPE P DECIMALS 2.
        DATA ZDCM_1 TYPE P DECIMALS 2.
        DATA ZDCH_1 TYPE P DECIMALS 2.
        DATA NettoPPLRsKg TYPE P DECIMALS 2.
       Net_Basic = ZPRI - ZDPQ .
IF wa_final-quantity IS NOT INITIAL.
  ZDCM_1 = ZDCM / wa_final-quantity.
ELSE.
  ZDCM_1 = 0.
ENDIF.


IF wa_final-quantity IS NOT INITIAL.
  ZDCH_1 = ZDCH / wa_final-quantity.
ELSE.
  ZDCH_1 = 0.
ENDIF.

NettoPPLRsKg = Net_Basic - ZDCH_1 - ( ZDCM_1 - ZDCH_1 ) - ZMOU - ZFCP - zadc.

      lv_xml1 =
            |<Row1>| &&
            |<SNO>{ wa_final-sno }</SNO>| &&
            |<MATCODE>{ wa_final-materialcode }</MATCODE>| &&
            |<MATDESC>{ wa_final-materialdesc }</MATDESC>| &&
            |<Basicprice>{ ZPRI DECIMALS = 2 }</Basicprice>| &&
            |<AddlDiscinInvRsKg>{ ZDPQ DECIMALS = 2 }</AddlDiscinInvRsKg>| &&
            |<NetBasicRsKg>{ Net_Basic  }</NetBasicRsKg>| &&
            |<DealerCommRsKg>{ ZDCM_1 }</DealerCommRsKg>| &&
            |<DealComminInvRsKg>{ ZDCH_1 }</DealComminInvRsKg>| &&
            |<AddDiscto>{ ZDCM_1 - ZDCH_1  DECIMALS = 2 }</AddDiscto>| &&
            |<Add_DisctodealerRsKg>{ zadc  DECIMALS = 2 }</Add_DisctodealerRsKg>| &&
            |<MOURsKg>{ ZMOU DECIMALS = 2 }</MOURsKg>| &&
            |<FreightBorneByPPLRsKg>{ ZFCP  DECIMALS = 2 }</FreightBorneByPPLRsKg>| &&
            |<NettoPPLRsKg>{ NettoPPLRsKg }</NettoPPLRsKg>| &&
            |<Qty>{ wa_final-quantity }</Qty>| &&
            |<amount></amount>|
            && |</Row1>|.
      CONCATENATE lv_xml2 lv_xml1 INTO lv_xml2.
      CLEAR lv_xml1.
      CLEAR : ZPRI, ZDPQ,ZDCM_1,Net_Basic,ZADC,ZDCH_1,ZDCH,NettoPPLRsKg,ZMOU,ZFCP.
    ENDLOOP.
    lv_xml3 = |<FooterRow>|   &&
              |<TOTQTY>{ lv_tot_qty }</TOTQTY>| &&
*              |<TOTNETVALUE>{ lv_tot_net }</TOTNETVALUE>| &&
              |<totalamount></totalamount>| &&
              |</FooterRow>| &&
              |</Table1>|.

    lv_xml4 =
              |<COMPBANK></COMPBANK>| &&
   |<ACCHOLD></ACCHOLD>| &&
   |<BANKNAME></BANKNAME>| &&
   |<ACCNO></ACCNO>| &&
   |<BRANCHIFSC></BRANCHIFSC>| &&
   |<FREIGHTCHARGES>{ lv_frieght }</FREIGHTCHARGES>| &&
   |<TAXAMT>{ lv_tot_amt }</TAXAMT>| &&
   |<IGST></IGST>| &&
   |<ROUNDOFF></ROUNDOFF>| &&
   |<GROSSTOTAL></GROSSTOTAL>| &&
   |<TextField1></TextField1>|.

    lv_xml5 =
*    |<Address>| &&
 |<AddA1>{ add1 }</AddA1>| &&
 |<ADDA2>{ add2 }</ADDA2>| &&
 |<ADDA3>{ add3 }</ADDA3>| &&
 |<ADDA4>{ add4 }</ADDA4>| &&
 |<ADDA5>{ add5 }</ADDA5>| &&
 |<GSTA1>{ gstin }</GSTA1>| &&
 |<PANA1>{ pan }</PANA1>| &&
 |<CINA1>{ cin }</CINA1>| &&
 |<MSME>{ lv_sale_off }</MSME>| &&
 |<ADDA6>{ add6 }</ADDA6>| &&
 |<WEBSITE>{ WESITE }</WEBSITE>| &&
* |</Address>|
 |<Subform3>| &&
 |<Freightcharges2>{ frtcharg }</Freightcharges2>| &&
 |<GrossTotal2>{ gt_value }</GrossTotal2>| &&
 |</Subform3>| &&
 |<Subform2>| &&
 |<COUNTRYOFORIGIN></COUNTRYOFORIGIN>| &&
 |</Subform2> | &&
 |</form1>|.


    CONCATENATE lv_xml lv_xml2 lv_xml3 lv_xml4 lv_xml5 INTO lv_xml6.

    CALL METHOD zadobe_print=>adobe
      EXPORTING
        xml       = lv_xml6
        form_name = 'Price_Approval_Print'
      RECEIVING
        result    = result12.


   "TR

  ENDMETHOD.
ENDCLASS.
