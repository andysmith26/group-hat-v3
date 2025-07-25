import { google } from 'googleapis';
import { 
  SHEET_ID, 
  GOOGLE_CLIENT_EMAIL, 
  GOOGLE_PRIVATE_KEY 
} from '$env/static/private';

// Production-ready authentication using environment variables
const auth = new google.auth.GoogleAuth({
  credentials: {
    client_email: GOOGLE_CLIENT_EMAIL,
    private_key: GOOGLE_PRIVATE_KEY?.replace(/\\n/g, '\n'), // Handle escaped newlines
  },
  scopes: ['https://www.googleapis.com/auth/spreadsheets']
});
const sheets = google.sheets({ version: 'v4', auth });

export async function getSheetRange(range: string) {
    console.log('Using Spreadsheet ID:', SHEET_ID);
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId: SHEET_ID!,
    range
  });
  return res.data.values ?? [];
}
