import { google } from 'googleapis';
import { readFileSync } from 'fs';
import { SHEET_ID } from '$env/static/private';

// Load credentials & initialize auth
const creds = JSON.parse(
  readFileSync(process.env.GOOGLE_SERVICE_ACCOUNT_KEYFILE!, 'utf-8')
);
const auth = new google.auth.GoogleAuth({
  credentials: creds,
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
