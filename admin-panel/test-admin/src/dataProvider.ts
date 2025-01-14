import simpleRestProvider from 'ra-data-simple-rest';

const API_URL = 'http://localhost:3000/api';

export const dataProvider = simpleRestProvider(API_URL);

