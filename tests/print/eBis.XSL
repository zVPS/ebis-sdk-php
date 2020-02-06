<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:schemas-biztalk-org:biztalk:biztalk_1" xmlns:n2="urn:www.basda.org/schema/eBIS-XML_order_v3.00.xml" xmlns:n3="urn:www.basda.org/schema/eBIS-XML_invoice_v3.00.xml" version="1.0">

<xsl:template match="/n1:biztalk_1">
	<HTML>
		<head>
			<title>MAM <xsl:value-of select="n1:body/n2:Order/n2:OrderHead/n2:OrderType"/>
				<xsl:value-of select="n1:body/n3:Invoice/n3:InvoiceHead/n3:InvoiceType"/>
			</title>
			<style><![CDATA[
				TD {
					VERTICAL-ALIGN: top;
				}
						
				.heading {
					font-family:Arial,Helvetica,sans-serif;
					font-size:10pt;
					font-weight:bold;
					margin-top:12pt;
					margin-bottom:12pt;
				}
				.subheading {
					font-family:Arial,Helvetica,sans-serif;
					font-size:10pt;
					font-weight:bold;
					margin-top:12pt;
					margin-bottom:12pt;
				}	
				.address {
					font-size:10pt;
					font-family:Arial,Helvetica,sans-serif;
				}

				.narrative {
					font-style:italic;
				}

				.delivsched{
					font-size:10pt;
				}
			]]></style>				
		</head>
		<body>
			<xsl:apply-templates select="//n2:Order"/>
			<xsl:apply-templates select="//n3:Invoice"/>		
			<p align="right"><font size="1">MAM / UAN Style Sheet 2.1 - Nov 15</font></p>
		</body>
	</HTML>
</xsl:template>


<xsl:template match="n2:Order">

	<div align="center">
	<table border="0" width="100%">
	<tr>
	<td width="60%" align="center">
		<div class="heading">
		<xsl:if test="n2:OrderHead/n2:OrderType[@Code='PUO']"><xsl:if test="n2:OrderHead/n2:Function[@Code='GRN']">Goods Received Note</xsl:if></xsl:if>
		<xsl:if test="n2:OrderHead/n2:OrderType[@Code='PUO']"><xsl:if test="n2:OrderHead/n2:Function[@Code!='GRN']">Purchase Order</xsl:if></xsl:if>
		<xsl:if test="n2:OrderHead/n2:OrderType[@Code='POR']">Purchase Order Acknowledgement</xsl:if>
		</div>
		<div class="subheading">
			<xsl:value-of select="n2:OrderHead/n2:Function"/>
		</div>
	</td>
	</tr>
	</table>
	
		<!-- =============== -->
		<!-- ORDER addresses -->
		<!-- =============== -->
			
		<table border="0" width="100%">
			<tr>
				<td width="33%" height="23" valign="top">Order To:-</td>
				<td width="1%" height="150" valign="top" rowspan="2"></td>
				<td width="32%" height="23" valign="top">Deliver To:</td>
				<td width="1%" height="150" valign="top" rowspan="2"></td>
				<td width="32%" height="23" valign="top">Invoice To:</td>					
			</tr>
			<tr>
				<td valign="top" bgcolor="#AAAAAA">
				  <DIV><xsl:value-of select="n2:Supplier/n2:Party"/></DIV>
                  <xsl:apply-templates select="n2:Supplier/n2:Address"/>
                </td>
				<td valign="top" bgcolor="#AAAAAA">
				  <DIV><xsl:value-of select="n2:Delivery/n2:DeliverTo/n2:Party"/></DIV>
				  <xsl:apply-templates select="n2:Delivery/n2:DeliverTo/n2:Address"/>
				</td>
				<td valign="top" bgcolor="#AAAAAA">
				  <DIV><xsl:value-of select="n2:InvoiceTo/n2:Party"/></DIV>
				  <xsl:apply-templates select="n2:InvoiceTo/n2:Address"/>
				</td>
			</tr>
		</table>
		
		<br/>
	  
		<!-- =========================== -->
		<!-- ORDER dates, references etc -->
		<!-- =========================== -->
		
		<table border="1" width="100%" height="68" bordercolor="black">
			<tr bgcolor="#000000" style="color:white;font-size:10pt;font-family:Arial,Helvetica;font-weight:bold">
				<td width="15%">Date</td>
				<td width="25%">		
					<xsl:choose>
					<xsl:when test="n2:OrderHead/n2:OrderType[@Code='PUO']">Our Ref</xsl:when>
					<xsl:otherwise>Your Ref</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="25%">
					<xsl:choose>
					<xsl:when test="n2:OrderHead/n2:OrderType[@Code='PUO']">Your Ref</xsl:when>
					<xsl:otherwise>Our Ref</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="20%">A/C No</td>
				<td width="15%">Ship Method</td>
			</tr>
			<tr>
				<td>
					<xsl:apply-templates select="n2:OrderDate"/>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="n2:OrderReferences/n2:BuyersOrderNumber"><xsl:value-of select="n2:OrderReferences/n2:BuyersOrderNumber"/></xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="n2:OrderReferences/n2:SuppliersOrderReference"><xsl:value-of select="n2:OrderReferences/n2:SuppliersOrderReference"/></xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose> 
						<xsl:when test="//n2:Order[Buyer/n2:BuyerReferences/n2:SuppliersCodeForBuyer=n2:Delivery/n2:DeliverTo/n2:DeliverToReferences/n2:BuyersCodeForDelivery]"><xsl:value-of select="n2:Buyer/n2:BuyerReferences/n2:SuppliersCodeForBuyer"/></xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="n2:Buyer/n2:BuyerReferences/n2:SuppliersCodeForBuyer">Buyer: <xsl:value-of select="n2:Buyer/n2:BuyerReferences/n2:SuppliersCodeForBuyer"/><br/></xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose> 
							<xsl:choose>
								<xsl:when test="n2:Delivery/n2:DeliverTo/n2:DeliverToReferences/n2:BuyersCodeForDelivery">Delivery: <xsl:value-of select="n2:Delivery/n2:DeliverTo/n2:DeliverToReferences/n2:BuyersCodeForDelivery"/></xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose> 
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="n2:Delivery/n2:Carrier/n2:Party"><xsl:value-of select="n2:Delivery/n2:Carrier/n2:Party"/></xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	  
		<br/>
	
		<!-- ================= -->
		<!-- ORDER contacts    -->
		<!-- ================= -->

		<table border="0" width="100%">
			<tr>
				<b>Contact: </b><xsl:value-of select="n2:Buyer/n2:Contact/n2:Name"/>
				<b>Tel: </b><xsl:value-of select="n2:Buyer/n2:Contact/n2:DDI"/>
			</tr>
		</table>
	  
		<br/>
		
		<!-- =========== -->
		<!-- ORDER lines -->
		<!-- =========== -->
		<table border="0" width="100%" height="108" cellpadding="5"> 
			<tr bgcolor="#AAAAAA" style="font-size:10pt;font-family:Arial,Helvetica">
				<td align="center">Line</td>
				<td align="center">Qty</td>
				<xsl:if test="//n2:OrderLine/n2:Quantity/n2:Packsize"><td align="center">Dimensions</td></xsl:if>
				<td align="center">Product Ref (Buyers Ref)</td>
				<td align="center">Description</td>
				<xsl:if test="//n2:Delivery/n2:PreferredDate"><td align="center">Due Date</td></xsl:if>
				<xsl:if test="//n2:OrderLine/n2:AmountDiscount"><td align="center" colspan="2">Discount</td></xsl:if>
				<td align="center">Unit Price</td>
				<td align="center">Total</td>
			</tr>
		    
			<xsl:apply-templates select="n2:OrderLine"/>
		    
		</table>
		

		<!-- =========== -->
		<!-- ORDER total -->
		<!-- =========== -->
		
		<table width="100%">
		<tr><td width="100%">
		<table border="3" width="30%" align="right">
			<tr>
				<td width="90%" align="right">Goods</td>
				<td width="10%" align="right"><xsl:apply-templates select="n2:OrderTotal/n2:GoodsValue"/></td>
			</tr>
			<tr>
				<td align="right">Tax</td>
				<td align="right"><xsl:apply-templates select="n2:OrderTotal/n2:TaxTotal"/></td>
			</tr>
			<tr>
				<td align="right">Total</td>
				<td align="right"><xsl:apply-templates select="n2:OrderTotal/n2:GrossValue"/></td>
			</tr>
		</table>
		</td>
		</tr>
		</table>
		<br/>

		<!-- ================ -->
		<!-- ORDER narratives -->
		<!-- ================ -->

		<DIV align="center" style="margin-top:40pt;"><xsl:apply-templates select="n2:Narrative" /></DIV>
		<DIV align="center" style="margin-top:12pt;"><xsl:apply-templates select="n2:SpecialInstructions" /></DIV>
		<DIV><xsl:value-of select="n2:SpecialInstructions" /></DIV>
		<DIV><xsl:value-of select="n2:Narrative" /></DIV>
	</div>
</xsl:template>


<xsl:template match="n3:Invoice">

	<div align="center">
		<div class="heading">
			<xsl:value-of select="n3:InvoiceHead/n3:InvoiceType"/>
			<xsl:if test="n3:INVOICEHEAD/n3:FUNCDESC"><xsl:if test="n3:INVOICEHEAD/n3:INVOICEDESC">
				- 
			</xsl:if></xsl:if>
			<xsl:value-of select="n3:INVOICEHEAD/n3:FUNCDESC"/>
		</div>
		
		<xsl:if test="REFERENCE[@REFTYPE='SUT']">
			<div style="font-weight:bold">Tax reference: <xsl:value-of select="REFERENCE[@REFTYPE='SUT']/REFCODE"/></div>
		</xsl:if>

		<!-- ================= -->
		<!-- INVOICE addresses -->
		<!-- ================= -->
		<table border="0" width="100%">
			<tr>
				<td width="24%">Invoice To:</td>
				<td width="1%" rowspan="2"></td>
				<td width="24%">Deliver To:</td>
				<td width="1%" rowspan="2"></td>
				<td width="24%">Delivered By:</td>
				<td width="1%" rowspan="2"></td>
				<td width="24%">Payment To:</td>
			</tr>
			<tr>
				<td bgcolor="#AAAAAA"><DIV><xsl:value-of select="n3:Buyer/n3:Party" /></DIV><xsl:apply-templates select="n3:Buyer/n3:Address" /></td>
				<td bgcolor="#AAAAAA"><DIV><xsl:value-of select="n3:Delivery/n3:DeliverTo/n3:Party" /></DIV><xsl:apply-templates select="n3:Delivery/n3:DeliverTo/n3:Address" /></td>
				<td bgcolor="#AAAAAA"><DIV><xsl:value-of select="n3:Supplier/n3:Party" /></DIV><xsl:apply-templates select="n3:Supplier/n3:Address" /></td>
				<td bgcolor="#AAAAAA">United Aftermarket Network Ltd<br />Roydsdale House<br />Roydsdale Way<br />Euroway Trading Estate<br />Bradford<br />BD4 6SE</td>
                        </tr>
		</table>
	  
		<br/>
		  
		<!-- ============================= -->
		<!-- INVOICE dates, references etc -->
		<!-- ============================= -->
	
		<table border="1" width="100%" height="68" bordercolor="black">
			<tr bgcolor="#000000" style="color:white;font-size:10pt;font-family:Arial,Helvetica;font-weight:bold">
				<td width="25%" >Date</td>
				<td width="25%">Our Ref</td>
				<td width="25%">Your Ref</td>
				<td width="25%">A/C No</td>
			</tr>
			<tr>
				<td><xsl:apply-templates select="n3:InvoiceDate"/></td>
				<td><xsl:value-of select="n3:InvoiceReferences/n3:SuppliersInvoiceNumber"/></td>
				<td>
					<xsl:choose>
						<xsl:when test="n3:InvoiceReferences/n3:BuyersOrderNumber"><xsl:value-of select="n3:InvoiceReferences/n3:BuyersOrderNumber" />&#160;</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="n3:Buyer/n3:BuyerReferences/n3:SuppliersCodeForBuyer"><xsl:value-of select="n3:Buyer/n3:BuyerReferences/n3:SuppliersCodeForBuyer"/></xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	  
		<br/>


		<!-- ============= -->
		<!-- INVOICE lines -->
		<!-- ============= -->

		<table border="0" width="100%" height="108" cellpadding="5"> 
			<tr bgcolor="#AAAAAA" style="font-size:10pt;font-family:Arial,Helvetica">
				<td align="center">Line</td>
				<td align="center">Qty</td>
				<xsl:if test="//n3:InvoiceLine/n3:DIMENSION"><td align="center">Dimensions</td></xsl:if>
				<xsl:if test="//n3:InvoiceLine/n3:Product/n3:SuppliersProductCode"><td align="center">Product Ref</td></xsl:if>
				<td align="center">Description</td>
				<td align="center">Orig Inv/Rtn Ref</td>
				<td align="center">Supp Xref1</td>
				<td align="center">Supp Xref2</td>
				<td align="center">Supp Xref3</td>
				<td align="center">Supp Xref4</td>
				<xsl:if test="//n3:InvoiceLine/n3:Discount"><td align="center" colspan="2">Discount</td></xsl:if>
				<td align="center">Unit Price</td>
				<td align="center">Total</td>
			</tr>
	    
			<xsl:apply-templates select="n3:InvoiceLine"/>
	    
		</table>
		
		
		<!-- ============= -->
		<!-- INVOICE total -->
		<!-- ============= -->
			
		<table width="100%">
		<tr><td width="100%">
		<table border="3" width="30%" align="right">
			<tr>
				<td width="90%" align="right">Goods</td>
				<td width="10%" align="right"><xsl:apply-templates select="n3:InvoiceTotal/n3:LineValueTotal"/></td>
			</tr>
			<tr>
				<td align="right">Vat</td>
				<td align="right"><xsl:apply-templates select="n3:InvoiceTotal/n3:TaxTotal"/></td>
			</tr>
			<tr>
				<td align="right">Total</td>
				<td align="right"><xsl:apply-templates select="n3:InvoiceTotal/n3:GrossPaymentTotal"/></td>
			</tr>
		</table>
		</td>
		</tr>
		</table>

		<!-- ================= -->
		<!-- INVOICE tax table -->
		<!-- ================= -->
		
		<table border="1" cellpadding="5">
			<tr>
				<td colspan="4" align="center">Tax Analysis</td>
			</tr>
			<tr>
				<td>Code</td>
				<td>Rate</td>
				<td>Goods</td>
				<td>Tax</td>
			</tr>
			<xsl:apply-templates select="n3:TaxSubTotal"/>
		</table>

		<!-- ================== -->
		<!-- INVOICE narratives -->
		<!-- ================== -->

				<DIV align="center" style="margin-top:12pt;"><xsl:apply-templates select="n3:SpecialInstructions" /></DIV>
				<DIV align="center" style="margin-top:40pt;"><xsl:apply-templates select="n3:Narrative" /></DIV>
	</div>
</xsl:template><!-- "INVOICE" -->

<xsl:template match="n2:OrderLine">
    <tr>
		<td align="center"><xsl:value-of select="n2:LineNumber"/></td>
			
		<td align="center"><xsl:value-of select="n2:Quantity/n2:Amount" /></td>
			
		<xsl:if test="/.//n2:OrderLine/n2:Quantity/n2:Packsize">
			<td align="center"><xsl:value-of select="n2:Quantity/n2:Packsize"/></td>
		</xsl:if>
			
		<td align="center">
			<xsl:value-of select="n2:Product/n2:SuppliersProductCode"/>
			<xsl:if test="n2:Product/n2:BuyersProductCode">
				<DIV>
				(
				<xsl:value-of select="n2:Product/n2:BuyersProductCode"/>
				)
				</DIV>
			</xsl:if>
		</td>

		<td align="left">
			<xsl:apply-templates select="n2:Product/n2:Description"/>
			<xsl:value-of select="n2:Narrative"/>
		</td>
		
		<xsl:if test="/.//n2:Delivery/n2:PreferredDate">
			<td align="center"><xsl:apply-templates select="n2:Delivery/n2:PreferredDate"/></td>
		</xsl:if>
		
		<xsl:if test="/.//n2:OrderLine/n2:AmountDiscount">
			<td align="center">
				<xsl:for-each select="n2:AmountDiscount"><DIV><xsl:value-of select="n2:Type"/></DIV></xsl:for-each>
			</td>
			<td align="center">
				<xsl:for-each select="n2:AmountDiscount"><DIV><xsl:value-of select="n2:Amount"/></DIV></xsl:for-each>
			</td>
		</xsl:if>
		
		<td align="right"><xsl:apply-templates select="n2:Price/n2:UnitPrice"/></td>
		
		<td align="right"><xsl:apply-templates select="n2:LineTotal"/></td>
    </tr>
</xsl:template><!-- "ORDERLINE" -->



<xsl:template match="n3:InvoiceLine">
    <tr>
		<td align="center"><xsl:value-of select="n3:LineNumber"/></td>
		
		<td align="center"><xsl:value-of select="n3:Quantity/n3:Amount" /></td>
		
		<xsl:if test="/.//n3:InvoiceLine/n3:Dimension">
			<td align="center"><xsl:apply-templates select="n3:Dimension"/></td>
		</xsl:if>
		
		<xsl:if test="/.//n3:InvoiceLine/n3:Product/n3:SuppliersProductCode">
			<td align="center">
				<xsl:apply-templates select="n3:Product/n3:SuppliersProductCode"/>
			</td>
		</xsl:if>
		<td align="center">
			<xsl:apply-templates select="n3:Product/n3:Description"/>
			<xsl:apply-templates select="n3:Narrative"/>
		</td>
		
		<td align="center">
		<xsl:choose>
		<xsl:when test="n3:InvoiceLineReferences/n3:DeliveryNoteNumber"><xsl:value-of select="n3:InvoiceLineReferences/n3:DeliveryNoteNumber" /></xsl:when>
		<xsl:when test="n3:InvoiceLineReferences/n3:ContractOrderReference"><xsl:value-of select="n3:InvoiceLineReferences/n3:ContractOrderReference" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="n3:InvoiceLineReferences/n3:BuyersOrderNumber" /></xsl:otherwise>
		</xsl:choose>
		</td>

				<xsl:if test="/.//n3:InvoiceLine/n3:Discount">
			<td align="center">
				<xsl:for-each select="n3:Discount"><DIV><xsl:value-of select="n3:DISCDESC"/></DIV></xsl:for-each>
			</td>
			<td align="center">
				<xsl:for-each select="n3:Discount"><DIV><xsl:apply-templates select="n3:DISCAMOUNT" /><xsl:apply-templates select="DISCMULT" /></DIV></xsl:for-each>
			</td>
		</xsl:if>
		<td align="center"><xsl:value-of select="n3:InvoiceLineReferences/n3:GeneralLedgerCode" /></td>
		<td align="center"><xsl:value-of select="n3:InvoiceLineReferences/n3:ProjectAnalysisCode" /></td>
		<td align="center"><xsl:value-of select="n3:Product/n3:TradedUnitCode" /></td>
		<td align="center"><xsl:value-of select="n3:Product/n3:ConsumerUnitCode" /></td>
		
		<td align="center"><xsl:apply-templates select="n3:Price/n3:UnitPrice" /></td>
		
		<td align="center"><xsl:apply-templates select="n3:LineTotal"/></td>
    </tr>
</xsl:template><!-- "InvoiceLine" -->



<xsl:template match="n2:Price/n2:UnitPrice|n2:LineTotal|n2:LineValueTotal|n2:GoodsValue|n2:TaxTotal|n2:GrossValue|n2:GrossPaymentTotal"><xsl:value-of select="format-number(., &quot;0.00&quot;)"/></xsl:template>

<xsl:template match="n2:Quantity/n2:Amount"><xsl:value-of select="n2:Quantity/n2:Amount"/> <xsl:value-of select="n2:QTYUOMDESC"/></xsl:template>


<xsl:template match="n2:Dimension"><DIV><xsl:value-of select="n2:DIMDESC"/>: <xsl:value-of select="n2:DIMVALUE"/> <xsl:value-of select="n2:DIMUOMDESC"/></DIV></xsl:template>

<xsl:template match="n2:SuppliersProductCode"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n2:Product/n2:Description"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n2:Narrative"><xsl:value-of select="n2:Narrative" /></xsl:template>

<xsl:template match="n2:SpecialInstructions"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n2:OrderDate|n3:InvoiceDate">
	<xsl:call-template name="formatDate">
		<xsl:with-param name="dateIn" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="n2:Delivery/n2:PreferredDate">
	<xsl:call-template name="formatDate">
		<xsl:with-param name="dateIn" select="."/>
	</xsl:call-template>
</xsl:template>


<xsl:template match="n2:Address">
	<SPAN class="address">
		<xsl:for-each select="n2:AddressLine"><DIV><xsl:value-of select="."/></DIV></xsl:for-each>
		<xsl:for-each select="n2:Street"><DIV><xsl:value-of select="."/></DIV></xsl:for-each>
		<DIV><xsl:value-of select="n2:City"/></DIV>
		<DIV><xsl:value-of select="n2:State"/></DIV>
		<DIV><xsl:value-of select="n2:Postcode"/></DIV>
		<DIV><xsl:value-of select="n2:Country"/></DIV>
	</SPAN>
</xsl:template><!-- "ADDRESS" -->


<xsl:template match="n2:TAXSUBTOTAL">
	<tr>
		<td><xsl:value-of select="n2:TAXCODE"/></td>
		<td><xsl:value-of select="n2:TAXRATE"/></td>
		<td><xsl:value-of select="n2:RATETAXBLVAL"/></td>
		<td><xsl:value-of select="n2:RATETAXVAL"/></td>
	</tr>
</xsl:template><!-- "TaxSubTotal" -->
<xsl:template match="n3:Price/n3:UnitPrice|n3:LineTotal|n3:LineValueTotal|n3:GoodsValue|n3:TaxTotal|n3:GrossValue|n3:GrossPaymentTotal"><xsl:value-of select="format-number(., &quot;0.00&quot;)"/></xsl:template>

<xsl:template match="n3:Quantity/n3:Amount"><xsl:value-of select="n3:Quantity/n3:Amount"/> <xsl:value-of select="n3:QTYUOMDESC"/></xsl:template>

<xsl:template match="n3:DISCMULT"><xsl:value-of select="."/>%</xsl:template>

<xsl:template match="n3:Dimension"><DIV><xsl:value-of select="n3:DIMDESC"/>: <xsl:value-of select="n3:DIMVALUE"/> <xsl:value-of select="n3:DIMUOMDESC"/></DIV></xsl:template>

<xsl:template match="n3:SuppliersProductCode"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n3:Product/n3:Description"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n3:Narrative"><xsl:value-of select="."/></xsl:template>

<xsl:template match="n3:SpecialInstructions"><DIV><xsl:value-of select="."/></DIV></xsl:template>

<xsl:template match="n3:Address">
	<SPAN class="address">
		<xsl:for-each select="n3:AddressLine"><DIV><xsl:value-of select="."/></DIV></xsl:for-each>
		<xsl:for-each select="n3:Street"><DIV><xsl:value-of select="."/></DIV></xsl:for-each>
		<DIV><xsl:value-of select="n3:City"/></DIV>
		<DIV><xsl:value-of select="n3:State"/></DIV>
		<DIV><xsl:value-of select="n3:Postcode"/></DIV>
		<DIV><xsl:value-of select="n3:Country"/></DIV>
	</SPAN>
</xsl:template><!-- "ADDRESS" -->

<xsl:template match="n3:TaxSubTotal">
	<tr>
		<td><xsl:value-of select="n3:TaxRate/@Code"/></td>
		<td><xsl:value-of select="n3:TaxRate"/></td>
		<td><xsl:value-of select="n3:TaxableValueAtRate"/></td>
		<td><xsl:value-of select="n3:TaxAtRate"/></td>
	</tr>
</xsl:template><!-- "TaxSubTotal" -->

<!--Parse date format: Mon, 04 Apr 2011 23:18:00 -0700-->
<xsl:template name="formatDate">

    <xsl:param name="dateIn"/>

    <xsl:variable name="year" select="substring($dateIn, 3, 2)"/>
    <xsl:variable name="month" select="substring($dateIn, 6, 2)"/>
    <xsl:variable name="date" select="substring($dateIn, 9, 2)"/>

	<xsl:choose>
		<xsl:when test="string-length($dateIn)=10">
			<xsl:value-of select="concat($date, '/', $month, '/', $year)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="hour" select="substring($dateIn, 12, 2)"/>
			<xsl:variable name="min" select="substring($dateIn, 15, 2)"/>		
			<xsl:value-of select="concat($date, '/', $month, '/', $year, ' ', $hour, ':', $min)"/>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>