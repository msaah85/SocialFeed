using Share.Business;
using Share.DataUtility;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Xml;

public class DataController : ApiController
{
    //[Route("data")]
    //Banks_SelectList
    [ActionName("LoadDataTables")]
    public string GetLoadDataTables() // [FromUri]SearchRequest request
    {
        var param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current; // NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
        param.sEcho = String.IsNullOrEmpty(Context.Request["sEcho"]) ? 0 : Convert.ToInt32(Context.Request["sEcho"]);
        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"];// asc or desc          


        // create filter parameters
        string[,] _params = {{"DisplayStart",param.iDisplayStart.ToString()}, {"DisplayLength", param.iDisplayLength.ToString()},
                             {"SearchParam", param.sSearch}, {"SortColumn", sortColumnIndex.ToString()}, {"SortDirection", sortDirection}};

        // get all of data.
        var _ds = new Select().SelectLists(Context.Request["funName"], _params);
        return LZString.CompressToUTF16(_ds.GetXml());        
    }

    [ActionName("GetData")]
    public string GetDataByID(string actionName, string value)
    {
        // create filter parameters
        string[,] _params = { { "Id", value } };

        // get all of data.
        var _ds = new Select().SelectLists(actionName, _params);
        return LZString.CompressToUTF16(_ds.GetXml());
    }

    public string GetDataDirect(string actionName)
    {
        // get all of data.
        var _ds = new Select().SelectLists(actionName);
        return LZString.CompressToUTF16(_ds.GetXml());
    }

    public string GetDataList(string actionName, string[] names, string[] values)
    {
        // get all of data.
        var _ds = new Select().SelectLists(actionName, names, values);
        return LZString.CompressToUTF16(_ds.GetXml());
    }

    /// <summary>
    /// Save data
    /// </summary>
    /// <param name="value">string actionName, string[] names, string[] values</param>
    /// <returns></returns>
    [ActionName("SaveData")]
    public object PostsaveData([FromBody]SaveDataObj value)
    {   // start save data.        
        var saved = new Save().SaveRow(value.actionName, value.names, value.values);
        object data = new { };

        if (saved != -1)
        {
            data = new
            {
                ID = saved,
                Status = true,
                message = Resources.sys.lang.SuccessSave
            };
        }
        else
        {
            data = new { ID = 0, status = false, message = Resources.sys.lang.ErrorSave };
        }

        return data;
    }

    [ActionName("SaveMasterDetails")]
    public object SaveMasterDetails(string actionName, string[] names, string[] values, string[] fieldsDetails, string[] valuesDetails, bool useIP = false)
    {
        var xmldoc = new XmlDocument();
        var doc = xmldoc.CreateElement("doc");
        xmldoc.AppendChild(doc);

        XmlElement xmlelement = xmldoc.CreateElement("Master");
        doc.AppendChild(xmlelement);

        for (int i = 0; i < values.Length; i++)
        {
            xmlelement.SetAttribute(names[i], values[i]);
        }

        if (useIP)
        {
            xmlelement.SetAttribute("UserId", SessionManager.Current.ID);
            xmlelement.SetAttribute("IP", SessionManager.Current.IP);
        }

        for (int i = 0; i < valuesDetails.Length; i++)
        {
            XmlElement xmlelementDetails = xmldoc.CreateElement("Details");
            doc.AppendChild(xmlelementDetails);
            xmlelementDetails.SetAttribute(names[0], values[0]);
            if (valuesDetails[0].Contains("لاتوجــد بيانات متاحة"))
            {
                for (int j = 0; j < fieldsDetails.Length; j++)
                {
                    xmlelementDetails.SetAttribute(fieldsDetails[j], "");
                }
            }
            else
            {
                for (int j = 0; j < fieldsDetails.Length; j++)
                {
                    string[] dataes = valuesDetails[i].Split(',');
                    xmlelementDetails.SetAttribute(fieldsDetails[j], dataes[j]);
                }
            }
        }

        object data = new { };
        SqlCommand command = DataAccess.CreateCommand();


        try
        {
            command.CommandText = actionName;
            command.Parameters.AddWithValue("@doc", xmldoc.OuterXml);
            var returnParameter = command.Parameters.Add("RetVal", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;

            int result = -1;
            command.Connection.Open();
            result = command.ExecuteNonQuery();
            if (result != -1)
            {
                data = new
                {
                    ID = returnParameter.Value,
                    Status = true,
                    message = "Data saved successfully."
                };
            }
        }
        catch (Exception ex)
        {
            data = new { ID = 0, status = false, message = ex.Message };
        }
        finally
        {
            command.Connection.Close();
        }
        return data;
    }

    [ActionName("login")]
    public object Getlogin(string text1, string text2)
    {
        // create filter paramters
        bool login_state = false;
        string _pass = EncryptDecryptString.Encrypt(text2, "Taj$$Key");
        string[,] _params = { { "Username", text1 }, { "Password", _pass } };

        // get all of data.
        var _ds = new Select().SelectLists("Users_Login", _params);

        var dt = _ds.Tables[0];
        if (dt.Rows.Count > 0)
        {
            SessionManager.Current.ID = string.Format("{0}", dt.Rows[0][0]);
            SessionManager.Current.Name = string.Format("{0}", dt.Rows[0][1]);
            //SessionManager.Current.Level = string.Format("{0}", dt.Rows[0][2]);

            CookiesManager.SaveCoockie();

            login_state = true;
        }

        return login_state;
    }

    [ActionName("checklogin")]
    public object Getchecklogin()
    {
        return new { Name = SessionManager.Current.Name };
    }

    [ActionName("decryptPassword")]
    public string GetDecryptPassword(string value)
    {
        return EncryptDecryptString.Decrypt(value, "Taj$$Key");
    }

    [ActionName("InlineEdit")]
    public string InlineEdit(string name, string value, string pk, string table, string id)
    {
        // inhance value
        value = value.Replace("'", " ");
        var isNumeric = !string.IsNullOrEmpty(value) && value.Replace(".", "").All(Char.IsDigit);
        if (!isNumeric)
        {
            value = string.Format("'{0}'", value);
        }

        // generate update sql string
        string sqlStr = string.Format("Update {0} SET {1}={2} WHERE {3}={4}", table, name, value, id, pk);
        var d = new Save().RunSQLString(sqlStr);

        //access params here
        return "Data saved successfully.";
    }
}