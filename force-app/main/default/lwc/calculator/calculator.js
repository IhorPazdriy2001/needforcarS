import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue, getFieldDisplayValue } from 'lightning/uiRecordApi';
import make__c from "@salesforce/schema/Product2.make__c";
import acountCategoryVal from "@salesforce/apex/priceValue.acountCategoryVal";
import createOpp from "@salesforce/apex/CreateOpportunity.createOpp";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Email from '@salesforce/schema/AccountBrand.Email';
import sendMail from "@salesforce/apex/SendMailForOrder.sendMail"
export default class Calculator extends LightningElement {
  @api recordId;

  @wire(getRecord, { recordId: '$recordId', fields: [make__c] })
  product;

  @wire(acountCategoryVal, {productId : '$recordId'})
  wiredPrice;
  

  get make() {
    return getFieldValue(this.product.data, make__c)
  }

  get price() {
    return this.wiredPrice?.data || 0
  }
  
  get year() {
 
    return [
        { label: '2005', value: '2005' },
        { label: '2006', value: '2006' },
        { label: '2007', value: '2007' },
        { label: '2008', value: '2008' },
        { label: '2009', value: '2009' },
        { label: '2010', value: '2010' },
        { label: '2011', value: '2011' },
        { label: '2012', value: '2012' },
        { label: '2013', value: '2013' },
        { label: '2014', value: '2014' },
        { label: '2015', value: '2015' },
        { label: '2016', value: '2016' },
        { label: '2017', value: '2017' },
        { label: '2018', value: '2018' },
        { label: '2019', value: '2019' },
        { label: '2020', value: '2020' },
        { label: '2021', value: '2021' },
        { label: '2022', value: '2022' },

    ];
}


resultPrice(){
  let firstInut = this.template.querySelector('lightning-input[data-id=inputPrice]').value;
  var valueOfPrise = Number(firstInut)

   
  let secondInut = this.template.querySelector('lightning-input[data-id=inputQuantity]').value;
  var valueOfQuantity = Number(secondInut)

  
  let thirdInput = this.template.querySelector('lightning-combobox[data-id=inputYear]').value;
  var valueOfYear = Number(thirdInput)


  let fourInut = this.template.querySelector('lightning-combobox[data-id=inputCountry]').value;
   
  let allPrise = 0;
  if(fourInut === 'USA') {
  allPrise =  ((valueOfPrise + (valueOfYear * 1.3) ) * valueOfQuantity ) + 1300
   console.log(allPrise)
  } else {
  allPrise =  ((valueOfPrise + (valueOfYear * 1.3) ) * valueOfQuantity ) + 800
    console.log(allPrise)
  }
  let expectedPrice = Math.round(allPrise)

  let fiveInput = this.template.querySelector('lightning-input[data-id=inputExpected]');
  fiveInput.value = expectedPrice;
  return valueOfQuantity , expectedPrice ;
}


quatityValue(){
  let quantuty = this.template.querySelector('lightning-input[data-id=inputQuantity]').value;
  return quantuty;
}
expectedPriceValue(){
  let expected = this.template.querySelector('lightning-input[data-id=inputExpected]').value;
  return expected;
}
YearValue(){
  let year = this.template.querySelector('lightning-combobox[data-id=inputYear]').value;
  return year;
}

plaseValue(){
  let plase = this.template.querySelector('lightning-combobox[data-id=inputCountry]').value;
  return plase;
}

get country() {
  return [
     
      { label: 'USA', value: 'USA' },
      { label: 'Europe', value: 'Europe' },
  ];
}


handleAccVall(){
  let Quantity = this.quatityValue();
  let expectedValue = this.expectedPriceValue();
  let YearCar = this.YearValue();
  let plaseToFit = this.plaseValue()
  createOpp({productId: this.recordId, expectpr: expectedValue, quntitycar: Quantity,yearOfCar: YearCar,regionOfCar: plaseToFit });

  const event = new ShowToastEvent({
    variant: "success",
    title: 'Successfully',
    message:
        'Your order has been successfully generated, our manager will contact you soon',
    });
  this.dispatchEvent(event);


let SubjectSend = "NeedForCar Order"
let bodySend = `Your order has been successfully formed, our manager will contact you soon`;
  sendMail( {subject: SubjectSend,body: bodySend });
  console.log("sad")
}



}