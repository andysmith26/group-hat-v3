import { google } from 'googleapis';
import { SHEET_ID } from '$env/static/private';

const auth = new google.auth.GoogleAuth({
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
