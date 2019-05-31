using System;
using System.Data;
using System.IO;
using System.Linq;

namespace EIDSS7Test.Util
{
    public static class CSVUtility
    {
        public static void ToCSV(this DataTable dtCL2, string strFilePath)
        {
            StreamWriter sw = new StreamWriter(strFilePath, false);
            //headers  
            for (int i = 0; i < dtCL2.Columns.Count; i++)
            {
                sw.Write(dtCL2.Columns[i]);
                if (i < dtCL2.Columns.Count - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
            foreach (DataRow dr in dtCL2.Rows)
            {
                for (int i = 0; i < dtCL2.Columns.Count; i++)
                {
                    string value = dr[i].ToString();
                    if (value.Contains(','))
                    {
                        value = String.Format("\"{0}\"", value);
                        sw.Write(value);
                    }
                    else
                    {
                        sw.Write(dr[i].ToString());
                    }
                    //if (!Convert.IsDBNull(dr[i]))
                    //{
                    //	string value = dr[i].ToString();
                    //	if (value.Contains(','))
                    //	{
                    //		value = String.Format("\"{0}\"", value);
                    //		sw.Write(value);
                    //	}
                    //	else
                    //	{
                    //		sw.Write(dr[i].ToString());
                    //	}
                    //}
                    if (i < dtCL2.Columns.Count - 1)
                    {
                        sw.Write(",");
                    }
                }
                sw.Write(sw.NewLine);
            }
            sw.Close();
        }
    }
}
