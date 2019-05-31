using System.IO;
using System.Data;

namespace EIDSS7Test.Util
{
    public class CSVData
    {
        //The code will read data from CSV file and put in the data table
        public static DataTable GetCSVData(string CSVFilePath)
        {
            StreamReader strRdr = new StreamReader(CSVFilePath);
            string[] hdrColNames = strRdr.ReadLine().Split(',');

            DataTable dtbl = new DataTable();

            foreach (string hdrColName in hdrColNames)
            {
                dtbl.Columns.Add(hdrColName);
            }
            while (!strRdr.EndOfStream)
            {
                string[] rows = strRdr.ReadLine().Split(',');
                DataRow dr = dtbl.NewRow();
                for (int i = 0; i < hdrColNames.Length; i++)
                {
                    dr[i] = rows[i];
                }
                dtbl.Rows.Add(dr);
            }
            return dtbl;
        }
    }
}
