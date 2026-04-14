CLASS zsd_salesorder_print DEFINITION
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



CLASS ZSD_SALESORDER_PRINT IMPLEMENTATION.


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
          cin          TYPE string,
          pan          TYPE string,
          gstin        TYPE string,
          msme         TYPE string,
          lv_address   TYPE string,
          lv_address1  TYPE string,
          lv_quatation TYPE string,
          lv_sono      TYPE string,
          lv_pono      TYPE string,
          lv_date      TYPE char10,
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
             materialcode TYPE i_salesdocumentitem-product,
             materialdesc TYPE i_salesdocumentitem-salesdocumentitemtext,
             hsncode      TYPE i_productplantbasic-consumptiontaxctrlcode,
             quantity     TYPE i_salesdocumentitem-orderquantity,
             uom          TYPE i_salesdocumentitem-baseunit,
             netprice     TYPE i_salesdocitempricingelement-conditionratevalue,
             discount     TYPE i_salesdocitempricingelement-conditionratevalue,
             netvalue     TYPE i_salesdocitempricingelement-conditionratevalue,
           END   OF ty_final.
    DATA: it_final TYPE TABLE OF ty_final,
          wa_final TYPE          ty_final.


    SELECT SINGLE plant FROM i_salesorderitem WHERE salesorder = @martdoc
          INTO @DATA(lv_plant).

    """"""""""Address
    msme = 'MSME/UDYAM-RJ-17-0509070 (Medium)'.
    add5 = 'Email:- jaipur@poddarpigmentsltd.com'.
    add6 =  'PHONE:- 0911412770202, 2770203, 2770287,  www.poddarpigmentsltd.com'.
    IF     lv_plant = '1000'.
      add1 = 'PODDAR PIGMENT LIMITED'.
      add2 = '(An ISO 9001:2015 Certified Company)'.
      add3 = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = ' Jaipur 302022'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E2ZY'.

    ELSEIF lv_plant = '1100'.
      add1 = 'PODDAR PIGMENT LIMITED'.
      add2 = '(An ISO 9001:2015 Certified Company)'.
      add3 = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area,Sitapura' .
      add4 = ' Jaipur 302022'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant = '1110'.
      add1 = 'PODDAR PIGMENT LIMITED'.
      add2 = '(An ISO 9001:2015 Certified Company)'.
      add3 = 'Greater Sitapura Industrial Park, National Highway 12' .
      add4 = '(Jaipur-Tonk Road), Brijpura village,Chaksu Jaipur 303901'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '08AAACP1125E1ZZ'.

    ELSEIF lv_plant = '1200'.
      add1 = 'PODDAR PIGMENT LIMITED'.
      add2 = '(An ISO 9001:2015 Certified Company)'.
      add3 = 'Rosy Tower, 3rd Floor 8, Mahatma Gandhi Road, Nungambakkam' .
      add4 = ' Chennai 600034'.
      cin  = 'L24117RJ1991PLC006307'.
      pan =  'AAACP1125E'.
      gstin = '33AAACP1125E3Z4'.
    ENDIF.

    """"""""""""""Sold To Party
    SELECT SINGLE customer FROM i_salesdocumentpartner WHERE salesdocument = @martdoc AND partnerfunction = 'WE'
           INTO @DATA(lv_customer).

    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesdocumentpartner WHERE salesdocument = @martdoc AND partnerfunction = 'AG'
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
       lv_add-cityname lv_add-postalcode
         lv_regionname lv_countryname INTO lv_address SEPARATED BY space.
    ENDIF.
    """"""""""""'Ship to party
    SELECT SINGLE customer FROM i_salesdocumentpartner WHERE salesdocument = @martdoc AND partnerfunction = 'RE'
               INTO @DATA(lv_customer1).
    SELECT SINGLE internationalmobilephonenumber, emailaddress FROM i_salesdocumentpartner WHERE salesdocument = @martdoc AND partnerfunction = 'WE'
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
       lv_add1-cityname lv_add1-postalcode
         lv_regionname1 lv_countryname1 INTO lv_address1 SEPARATED BY space.
    ENDIF.

    """"""""""Quotation No. / Date
    SELECT SINGLE precedingdocument FROM i_salesdocumentprecdgprocflow
         WHERE salesdocument = @martdoc INTO @DATA(lv_prece) .
    IF lv_prece IS NOT INITIAL.
      SELECT SINGLE salesdocument, creationdate FROM I_SalesDocument
       WHERE salesdocument = @lv_prece INTO @DATA(lv_quation) .
      CONCATENATE lv_quation-creationdate+6(2) '-' lv_quation-creationdate+4(2) '-' lv_quation-creationdate+0(4)
      INTO lv_date.
      CONCATENATE lv_quation-salesdocument '/' lv_date INTO lv_quatation SEPARATED BY space.

    ENDIF.
    """""""sales order No Date
    SELECT SINGLE salesdocument, creationdate, purchaseorderbycustomer,
                  customerpurchaseorderdate,
                  customerpaymentterms,
                  incotermsclassification,
                  incotermslocation1 FROM i_salesdocument
    WHERE salesdocument = @martdoc INTO @DATA(lv_document).
    IF lv_document IS NOT INITIAL.
      CONCATENATE lv_document-creationdate+6(2) '-' lv_document-creationdate+4(2) '-' lv_document-creationdate+0(4)
               INTO lv_date1.
      CONCATENATE lv_document-salesdocument '/' lv_date1 INTO lv_sono SEPARATED BY space.

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
      SELECT SINGLE customer FROM i_salesdocumentpartner WHERE salesdocument = @martdoc AND partnerfunction = 'ZD'
                                     INTO @DATA(lv_cust) .
      IF lv_cust IS NOT INITIAL.
        SELECT SINGLE bpcustomerfullname   FROM i_customer WHERE customer = @lv_cust
                                       INTO @DATA(lv_bpcusname).
      ENDIF.
    ENDIF.


    """"""""""""""""'For Table Data
    SELECT
          a~product,
          a~salesdocumentitemtext,
          a~salesdocumentitem,
          a~salesdocument,
          a~orderquantity,
          a~baseunit,
          b~consumptiontaxctrlcode
               FROM i_salesdocumentitem AS a
               LEFT OUTER JOIN i_productplantbasic AS b ON ( b~product = a~product AND b~Plant = a~Plant )
                WHERE salesdocument = @martdoc
               INTO TABLE @DATA(it_doc).

    IF it_doc IS NOT INITIAL.

      """""""""Net Value
      SELECT

                salesdocumentitem,
                salesdocument,
                conditionratevalue,
                ConditionCurrency
                FROM i_salesdocitempricingelement
                FOR ALL ENTRIES IN @it_doc WHERE salesdocument = @it_doc-salesdocument
                                           AND   salesdocumentitem = @it_doc-salesdocumentitem
                                           AND   conditiontype = 'ZPRI'
                 INTO TABLE @DATA(it_netvalue).

      """""""""""Discount
      SELECT

               salesdocumentitem,
               salesdocument,
               conditionratevalue
               FROM i_salesdocitempricingelement
               FOR ALL ENTRIES IN @it_doc WHERE salesdocument = @it_doc-salesdocument
                                          AND   salesdocumentitem = @it_doc-salesdocumentitem
                                          AND   conditiontype IN ( 'ZDPQ', 'ZDCH' )
                INTO TABLE @DATA(it_discount).


      """"""""""""""Freight Charges

      SELECT

              salesdocumentitem,
              salesdocument,
              conditionamount
              FROM i_salesdocitempricingelement
              FOR ALL ENTRIES IN @it_doc WHERE salesdocument = @it_doc-salesdocument
                                         AND   salesdocumentitem = @it_doc-salesdocumentitem
                                         AND   conditiontype = 'ZFPW'
               INTO TABLE @DATA(it_frieght).

      """"""""""""TOTAL TAXABLE AMOUNT
      SELECT

             salesdocumentitem,
             salesdocument,
             conditionbaseamount
             FROM i_salesdocitempricingelement
             FOR ALL ENTRIES IN @it_doc WHERE salesdocument = @it_doc-salesdocument
                                        AND   salesdocumentitem = @it_doc-salesdocumentitem
                                        AND   conditiontype = 'ZTIV'
              INTO TABLE @DATA(it_tot).

   """""""""""

   SELECT
         SINGLE salesoffice From I_SalesDocument WHERE SalesDocument = @martdoc
         into @DATA(lv_salesoffice).
         if lv_salesoffice is NOT INITIAL.
   SELECT SINGLE salesofficename from I_SalesOfficeText WHERE SalesOffice = @lv_salesoffice AND Language = 'E'
        into @DATA(lv_salesofficename).
        CONCATENATE 'Sales Office:'  lv_salesofficename INTO lv_sale_off SEPARATED BY space.
         ENDIF.






      LOOP AT it_doc INTO DATA(wa_doc).
        n = n + 1.
        wa_final-sno = n.
        CONDENSE wa_final-sno.
        wa_final-materialcode = wa_doc-product.
        wa_final-materialdesc = wa_doc-salesdocumentitemtext.
        wa_final-hsncode = wa_doc-consumptiontaxctrlcode.
        wa_final-quantity = wa_doc-orderquantity.
        wa_final-uom     = wa_doc-baseunit.

        READ TABLE it_netvalue INTO DATA(wa_netvalue) WITH KEY salesdocument = wa_doc-salesdocument
                                                               salesdocumentitem = wa_doc-salesdocumentitem.
        IF sy-subrc = 0.
          wa_final-netprice = wa_netvalue-conditionratevalue.
        ENDIF.

        LOOP AT it_discount INTO DATA(wa_discount) WHERE salesdocument = wa_doc-salesdocument AND salesdocumentitem = wa_doc-salesdocumentitem.

          wa_final-discount = wa_final-discount + wa_discount-conditionratevalue.
        ENDLOOP.

        IF wa_final-discount < 0.
          wa_final-discount = wa_final-discount * -1.
        ENDIF.
        wa_final-netvalue = wa_final-netprice - wa_final-discount.

        lv_tot_qty = lv_tot_qty + wa_final-quantity.
        lv_tot_net = lv_tot_net + wa_final-netvalue.

        LOOP AT it_frieght INTO DATA(wa_frieght) WHERE salesdocument = wa_doc-salesdocument AND salesdocumentitem = wa_doc-salesdocumentitem.

          lv_frieght = lv_frieght + wa_frieght-conditionamount.
        ENDLOOP.


        LOOP AT it_tot INTO DATA(wa_tot) WHERE salesdocument = wa_doc-salesdocument AND salesdocumentitem = wa_doc-salesdocumentitem.

          lv_tot_amt = lv_tot_amt + wa_tot-conditionbaseamount.
        ENDLOOP.



        APPEND wa_final TO it_final.

        CLEAR: wa_final.

      ENDLOOP.

    ENDIF.

    lv_xml = |<form1>| &&
                  |<soldparty>{ lv_address1 }</soldparty>| &&
                  |<GST1>{ lv_cust_name-taxnumber3 }</GST1>| &&
                  |<PAN1>{ lv_pan1 }</PAN1>| &&
                  |<EMAIL1>{ lv_shipmob-emailaddress }</EMAIL1>| &&
                  |<MOBNO1>{ lv_shipmob-internationalmobilephonenumber }</MOBNO1>| &&
                  |<shipparty>{ lv_address }</shipparty>| &&
                  |<GST2>{ lv_cust_name1-taxnumber3 }</GST2>| &&
                  |<PAN2>{ lv_pan2 }</PAN2>| &&
                  |<EMAIL2>{ lv_soldmob-emailaddress }</EMAIL2>| &&
                  |<MOBNO2>{ lv_soldmob-internationalmobilephonenumber }</MOBNO2>| &&
                  |<QuotationNo>{ lv_quatation }</QuotationNo>| &&
                  |<SONo>{ lv_sono }</SONo>| &&
                  |<PONo>{ lv_pono }</PONo>| &&
                  |<Paymentterms>{ lvpptterms }</Paymentterms>| &&
                  |<Deliveryterms>{ lv_dterms }</Deliveryterms>| &&
                  |<Dealer>{ lv_bpcusname }</Dealer>|
                  &&
                  |<Table1>| &&
                  |<HeaderRow>| &&
                  |<currcy>{ wa_netvalue-ConditionCurrency }</currcy>| &&
                  |</HeaderRow>| .

    LOOP AT it_final INTO wa_final.

      lv_xml1 =
            |<Row1>| &&
            |<SNO>{ wa_final-sno }</SNO>| &&
            |<MATCODE>{ wa_final-materialcode }</MATCODE>| &&
            |<MATDESC>{ wa_final-materialdesc }</MATDESC>| &&
            |<HSNCODE>{ wa_final-hsncode }</HSNCODE>| &&
            |<QTY>{ wa_final-quantity }</QTY>| &&
            |<UOM>{ wa_final-uom }</UOM>| &&
            |<NETPRICE>{ wa_final-netprice }</NETPRICE>| &&
            |<DISCOUNT>{ wa_final-discount }</DISCOUNT>| &&
            |<NETVALUE>{ wa_final-netvalue }</NETVALUE>| &&
            |<Amount></Amount>|
            && |</Row1>|.
      CONCATENATE lv_xml2 lv_xml1 INTO lv_xml2.
      CLEAR lv_xml1.
    ENDLOOP.
    lv_xml3 = |<FooterRow>|   &&
              |<TOTQTY>{ lv_tot_qty }</TOTQTY>| &&
              |<TOTNETVALUE></TOTNETVALUE>| &&
              |<amounttotal></amounttotal>| &&
              |</FooterRow>| &&
              |</Table1>|.


**********************************************************************

*LOOPING DATA END
************************************

      DATA total TYPE p DECIMALS 2 .
      DATA bas TYPE  string .
      DATA bas1 TYPE  string .
      DATA bas2 TYPE  string .
      DATA bas3 TYPE  string .
      DATA CART_P TYPE string.
      DATA discount_rate1 TYPE string.
      data COMMrate TYPE p DECIMALS 2.

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZFFA' ,'ZFMK','ZFDO','ZFOC' ) AND SalesDocument = @lv_document-salesdocument  INTO @DATA(freight)  .

 SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZFFA'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(freight_ffa)  .

 SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'ZD02' )   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(discount)  .

 SELECT SINGLE conditionrateratio FROM I_SalesDocItemPricingElement WHERE conditiontype =  'ZD02'
      AND SalesDocument = @lv_document-salesdocument INTO @DATA(discount_rate)  .
       discount_rate1 = discount_rate.
      CONCATENATE '(' discount_rate1+0(3) '%'  ')' INTO discount_rate1 .

 SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'ZD03' )   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(discount_Fix_Amt)  .

 SELECT SUM( ConditionRateAmount ) FROM I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZD03'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(DISC_FIX_P)  .

   SELECT SINGLE ConditionAmount FROM I_SalesDocItemPricingElement WHERE conditiontype =  'ZTOD'
      AND SalesDocument = @lv_document-salesdocument INTO @DATA(COMM)  .

      SELECT SINGLE conditionrateratio FROM I_SalesDocItemPricingElement WHERE conditiontype =  'ZTOD'
      AND SalesDocument = @lv_document-salesdocument   INTO @COMMrate .
*

*      if discount is not INITIAL .
* data(discount_rate1) = discount_rate && '%' .
*
* endif .

       SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'ZFFA' ) AND SalesDocument = @lv_document-salesdocument  INTO @data(freight_fix)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
     conditiontype EQ  'ZLDA' AND SalesDocument = @lv_document-salesdocument  INTO @DATA(loading)  .


      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
     conditiontype EQ  'ZP01' AND SalesDocument = @lv_document-salesdocument   INTO @DATA(packing)  .


      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'ZINS','ZDIN', 'ZI01' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(ins)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'JTC1' , 'JTCB' , 'JTC2' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(tcs)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'DRD1' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(rof)  .


      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'JOSG', 'JOCG','JOIG','JOUG' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(gst)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'JOSG' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(sgst)  .
      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'JOCG' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(cgst)  .
      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype IN ( 'JOIG' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(igst1)  .

     SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZMND'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(MND_AMT)  .
     SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZROL'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(ROLL_AMT)  .

     SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZC01'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(CART_AMT)  .
     SELECT SUM( ConditionRateAmount ) FROM I_SalesDocItemPricingElement WHERE
      conditiontype =  'ZC01'   AND SalesDocument = @lv_document-salesdocument  INTO @DATA(CART_Per)  .
             CART_P = CART_Per.
*      CONCATENATE '(' CART_P+0(3) '%'  ')' INTO CART_P .


      CLEAR bas .

      SELECT  * FROM  i_address_2 INTO TABLE  @DATA(address)  .

      SELECT SINGLE * FROM I_SalesDocItemPricingElement WHERE conditiontype IN ( 'JOSG',  'JOCG' )
      AND SalesDocument = @lv_document-salesdocument INTO @DATA(cgst_rate)  .
      IF cgst_rate IS NOT INITIAL .
        bas  =  cgst_rate-conditionrateratio .
        CONCATENATE '(' bas+0(3) '%' ')' INTO bas .
      ENDIF .

      SELECT SINGLE * FROM I_SalesDocItemPricingElement WHERE conditiontype IN ( 'JOIG' )
      AND SalesDocument = @lv_document-salesdocument INTO @DATA(igst_rate)  .
      IF igst_rate IS NOT INITIAL .
        bas1  =  igst_rate-conditionrateratio.
        CONCATENATE '(' bas1+0(3) '%'  ')' INTO bas1 .
      ENDIF .

*      SELECT SINGLE * FROM I_SalesOrderItemPricingElement WHERE conditiontype IN ( 'ZTCS','JTC1' )
*      AND SalesOrder = @salesorderno INTO @DATA(tcs_rate)  .
*      IF tcs_rate IS NOT INITIAL .
*        bas2  = tcs_rate-conditionrateratio . .
*        CONCATENATE '('  bas2+0(4) '%' ')' INTO bas2 .
*      ENDIF .

      SELECT SINGLE * FROM I_SalesDocItemPricingElement WHERE conditiontype IN ( 'JTCB' )
      AND SalesDocument = @lv_document-salesdocument INTO @DATA(tcs_rate)  .
      IF tcs_rate IS NOT INITIAL .
        bas2  = tcs_rate-conditionrateratio . .
        CONCATENATE '('  bas2+0(4) '%' ')' INTO bas2 .
      ENDIF .

      DATA grandtotal TYPE P DECIMALS 2 .
      DATA grandtotal1 TYPE string .
      DATA roundoff TYPE P DECIMALS 2 .

*      grandtotal  = subtot + freight + ins + gst +  tcs + loading  + packing .
      grandtotal  = ins + gst +  tcs + loading  + packing  + freight_fix  + discount + MND_AMT + ROLL_AMT.
      grandtotal1 = grandtotal .
      SPLIT grandtotal1 AT '.' INTO DATA(a) DATA(b) .

      IF b GE 50 .
        grandtotal = a + 1 .
        roundoff = grandtotal - grandtotal1 .
      ELSE .
        grandtotal = a .
        roundoff = grandtotal - grandtotal1 .

      ENDIF .

DATA AMT TYPE P DECIMALS 2.
"""""""""""""""""""""""""""""""""add nsp """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZR00' ,'ZR01' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(netamtn)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZCHD','ZD02','ZD03' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(dISAMTN)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZI01','ZI02' ) AND SalesDocument = @lv_document-salesdocument INTO @DATA(INSURANCE)  .

      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'JOIG','JOCG','JOSG' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(GSTn)  .

            SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZC01','ZP01','ZPOS','ZP02' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(Oth)  .

            SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype = 'ZCDI'  AND SalesDocument = @lv_document-salesdocument INTO @DATA(CASH)  .

            SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZFO1','ZFO2','ZFO3' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(FEST)  .


      SELECT SUM( conditionamount ) FROM  I_SalesDocItemPricingElement  WHERE
      conditiontype IN ( 'ZGIV' )  AND SalesDocument = @lv_document-salesdocument INTO @DATA(ZGIV)  .

      AMT = netamtn + DISAMTN + COMM.
   data(total_amt)   =  amt + gstN + INSURANCE + Oth.

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      TYPES: BEGIN OF ty1,
               batch TYPE string,
             END OF ty1 .
      DATA : batch1 TYPE TABLE OF ty1 .
*SELECT SINGLE * FROM zinv_tmg_table WHERE plant = @plant INTO @DATA(POLICY).

  data BCI type string.
  data tot_amt TYPE p DECIMALS 2.
  data tot_amt1 TYPE p DECIMALS 2.
  data totval TYPE p DECIMALS 2.
   DATA gstr TYPE string.

tot_amt = lv_tot_amt + gstN + INSURANCE + Oth + CASH + FEST.
totval  = CASH + lv_tot_amt .
tot_amt1 = fest  + totval .
"tot_amt1 = cash - tot_amt1 .


*if bas1 = 0.
*bas1 = ''.
*bas = ''.
*else.
*bas1 =  bas1 .
*bas =  bas.
*ENDIF.
**********************************************************************
























    lv_xml4 =
              |<COMPBANK></COMPBANK>| &&
   |<ACCHOLD></ACCHOLD>| &&
   |<BANKNAME></BANKNAME>| &&
   |<ACCNO></ACCNO>| &&
   |<BRANCHIFSC></BRANCHIFSC>| &&
   |<FREIGHTCHARGES>{ lv_frieght }</FREIGHTCHARGES>| &&
   |<TAXAMT>{ lv_tot_amt }</TAXAMT>| &&
   |<IGST>{ igst1 }</IGST>| &&
   |<SGST>{ sgst }</SGST>| &&
   |<SGST_P>{ bas }</SGST_P>| &&
   |<IGST_P>{ bas1 }</IGST_P>| &&
   |<CGST>{ cgst }</CGST>| &&
   |<CGST_P>{ bas }</CGST_P>| &&
   |<ROUNDOFF>{ rof * -1 }</ROUNDOFF>| &&
   |<GROSSTOTAL>{ ZGIV }</GROSSTOTAL>| &&
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
 |<ADDA6>{ add6 }</ADDA6>|
* |</Address>|
  && |</form1>|.


    CONCATENATE lv_xml lv_xml2 lv_xml3 lv_xml4 lv_xml5 INTO lv_xml6.

    REPLACE ALL OCCURRENCES OF '&' IN lv_xml6 WITH 'and'.

    " --- Pass XML to Adobe form ---
    CALL METHOD zadobe_print=>adobe
      EXPORTING
        xml       = lv_xml6
        form_name = 'sale_order_print'
      RECEIVING
        result    = result12.

  ENDMETHOD.
ENDCLASS.
