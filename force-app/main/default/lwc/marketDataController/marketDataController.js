import { LightningElement, track } from 'lwc';
import getMarketData from '@salesforce/apex/MarketDataController.getMarketData';

export default class MarketDataController extends LightningElement {
    @track stockSymbol = 'AAPL'; // Default stock symbol, tracked for reactivity.
    @track marketData; // To store and display the fetched market data.
    @track historicalData = []; // Array to hold historical time series data.
    
    // Columns definition for the lightning-datatable
    columns = [
        { label: 'Date', fieldName: 'date', type: 'text' },
        { label: 'Open', fieldName: 'open', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'High', fieldName: 'high', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Low', fieldName: 'low', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Close', fieldName: 'close', type: 'number', cellAttributes: { alignment: 'left' } },
        { label: 'Volume', fieldName: 'volume', type: 'number', cellAttributes: { alignment: 'left' } }
    ];

    // This method updates the stockSymbol property based on user input.
    handleSymbolChange(event) {
        this.stockSymbol = event.target.value;
    }

    // This method is called when the user clicks the "Fetch Data" button.
    fetchMarketData() {
        getMarketData({ symbol: this.stockSymbol })
            .then(result => {
                this.marketData = result; // Store the raw JSON result for debugging.

                if (result) {
                    // Parsing the JSON string into an object.
                    const parsedResult = JSON.parse(result);
                    const timeSeries = parsedResult["Time Series (Daily)"];

                    if (timeSeries) {
                        // Transform the time series into an array of objects for each date.
                        this.historicalData = Object.entries(timeSeries).map(([date, data]) => {
                            return {
                                date: date, // The key used for the date column in the table
                                open: data["1. open"],
                                high: data["2. high"],
                                low: data["3. low"],
                                close: data["4. close"],
                                volume: data["5. volume"]
                            };
                        });

                        // Sort the data by date in descending order and take the first 10 records
                        this.historicalData.sort((a, b) => new Date(b.date) - new Date(a.date));
                        this.historicalData = this.historicalData.slice(0, 15);
                    } else {
                        this.historicalData = []; // Clear data if none found
                    }
                } else {
                    this.marketData = "No result from API."; // Display a message if no result
                }
            })
            .catch(error => {
                // Handling any errors that occur during the API call.
                this.marketData = `Error fetching data: ${error}`;
                this.historicalData = []; // Clear data on error
            });
    }
}
