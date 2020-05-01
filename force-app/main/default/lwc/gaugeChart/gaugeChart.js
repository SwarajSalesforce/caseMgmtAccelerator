import { LightningElement, api } from "lwc";
import getCaseData from "@salesforce/apex/gaugeChartController.getCaseData";
export default class GaugeChart extends LightningElement {
  percentage;
  hours =0;
  minutes = 0;

  @api objectApiName;
  @api recordId;

  get getStyle() {
    return "width:" + this.percentage + "%";
  }
  get barText() {
    return `${this.hours} hours, ${this.minutes} min remaining`;
  }

  get className(){
    return this.hours <= 3 ? 'myBar danger' : (this.hours > 3 && this.hours < 9) ? 'myBar warning' : 'myBar'
  }
  @api changeBarColor() {
    this.className =
      this.className === this.defaultColor
        ? this.dangerColor
        : this.defaultColor;
  }

  connectedCallback() {
    console.log(this.recordId);
    let id = this.recordId;
    console.log(this.objectApiName);
    getCaseData({ id })
      .then(result => {
        console.log(result);
        this.progressHandler(result);
      })
      .catch(error => {
        console.error(error);
      });
  }

  progressHandler(data) {
    let result = data ? data[0] :{}
    this.hours = Math.floor((result.Time_remaining_to_close__c / (1000 * 60 * 60)) % 60);
    console.log(this.hours)
    this.minutes = Math.floor((result.Time_remaining_to_close__c / (1000 * 60)) % 60);
    let totalHour = result.Liner_brand__c === 'Wholesale' ? 15 :12;
    let totalMiliSeconds = totalHour*3600*1000;
    let remainingMiliSeconds = result.Time_remaining_to_close__c;
    let percentCompleted = ((totalMiliSeconds - remainingMiliSeconds) / totalMiliSeconds)*100;
    this.percentage = percentCompleted.toString();
  }

}