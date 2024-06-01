import { LightningElement, wire, track, api } from 'lwc';
import getWeatherData from '@salesforce/apex/WeatherService.getWeatherData';

export default class WeatherComponent extends LightningElement {
    @api latitude = 37.7749; // Example latitude
    @api longitude = -122.4194; // Example longitude
    @track weatherData;
    error;

    @wire(getWeatherData, { latitude: '$latitude', longitude: '$longitude' })
    wiredWeather({ error, data }) {
        if (data) {
            this.weatherData = {
                temp: data.current.temp,
                description: data.current.weather[0].description
            };
        } else if (error) {
            // Properly handle and display the error message
            this.error = error.body ? error.body.message : error.message;
        }
    }
}
