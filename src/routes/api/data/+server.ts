import type { RequestHandler } from '@sveltejs/kit';
import { getSheetRange } from '$lib/server/googleSheets';

export const GET: RequestHandler = async () => {
  const students = await getSheetRange('Books!A:C');
  // …fetch other ranges...
  return new Response(JSON.stringify({ students }), {
    headers: { 'Content-Type': 'application/json' }
  });
};
