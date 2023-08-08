using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;


namespace ClientDashBoard.WebServices
{
    /// <summary>
    /// Summary description for clientdash
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]

    public class clientdash : System.Web.Services.WebService    
    {
        public class clsZeptoEmail
        {
            public string bounce_address = "bounce@bounce.acsonnet.com";
            public clszeptoemailaddrFromAddress from = new clszeptoemailaddrFromAddress();
            public List<clszeptoemailaddr> reply_to = new List<clszeptoemailaddr>();
            public List<clszeptoemailaddrto> to = new List<clszeptoemailaddrto>();
            public List<clszeptoemailaddrto> cc = null;
            public List<clszeptoemailaddrto> bcc = null;
            public string subject = "";
            public string htmlbody = "";
            public List<clszeptoattachment> attachments;


        }
        public class clszeptoattachment
        {
            public string content = "";
            public string mime_type = "";
            public string name = "";
        }
        public class clszeptoemailaddrFromAddress
        {
            public string address = "no-reply@acsonnet.com";
            public string name = "";
        }
        public class clszeptoemailaddr
        {
            public string address = "";
            public string name = "";
            public clszeptoemailaddr()
            {
            }
            public clszeptoemailaddr(string saddress)
            {
                address = saddress;
            }
        }
        public class clszeptoemailaddrto
        {
            public clszeptoemailaddrto()
            {
            }
            public clszeptoemailaddrto(string emailaddress)
            {
                email_address.address = emailaddress;
            }
            public clszeptoemailaddr email_address = new clszeptoemailaddr();
        }
        public class Msg
        {
            public bool IsSaved = default(bool);
            public string Code = string.Empty;
            public string Patno = string.Empty;
            public string LABNO = string.Empty;
            public string Rectno = string.Empty;
            public string Pcode = string.Empty;
            public string ErrorMsg = string.Empty;
            public string SurgeryCode = string.Empty;
            public string SuccessMsg = string.Empty;
            public string OrderNO = string.Empty;
            public string ACTIONAPI = string.Empty;
            public string ACTIONAPIDATA = string.Empty;
            public string SuccessDirectUrl = string.Empty;
            public string FailureDirectUrl = string.Empty;
            public string username = string.Empty;
            public DateTime date;
            public bool iscancel = default(bool);
            public bool IsGet = default(bool);
        }
        public class cls_backup_client
        {
            public string code = string.Empty;
            public string name = string.Empty;
            public string connection_string = string.Empty;
            public string ap_db_name = string.Empty;
            public string aplab_db_name = string.Empty;
            public string pharmacy_db_name = string.Empty;
        }

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        

        [WebMethod(EnableSession = true)]
        public Msg deleteClientData(cls_backup_client obj)
        {
            Msg objmsg = new Msg();
            SqlConnection conn = new SqlConnection();
            SqlTransaction trans = null;
            try
            { 
                conn.ConnectionString = "Data Source=192.168.1.100; User Id=a; Password=a; Initial Catalog=SimpleBillApplication; Integrated Security=false";
                conn.Open();
                trans = conn.BeginTransaction();

                string qry = "select * from ' where code='" + (obj.code).Trim() + "'";
                SqlCommand cmd = new SqlCommand(qry,conn);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                
                if(dt!=null && dt.Rows.Count > 0)
                {
                    
                    string str="delete from BackupClients where code='" + (obj.code).Trim() + "'";
                    cmd = new SqlCommand(str, conn, trans);
                    cmd.ExecuteNonQuery();

                }
                else
                {
                    throw new Exception("This code is not exist");
                }


                trans.Commit();
                objmsg.IsSaved = true;
                objmsg.SuccessMsg = "Delete Successfully!!";

            }
            catch (Exception ex)
            {
                objmsg.IsSaved = false;
                trans.Rollback();
                
                objmsg.ErrorMsg = ex.Message;
            }
            finally
            {
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }

            //throw ex;



            return objmsg;
        }

        [WebMethod(EnableSession = true)]
        public Msg sendbackupmail()
        {
            Msg objmsg = new Msg();
            
            try
            {

                string sub = "";
                List<List<cls_backup_track>> arrstatus = getbackupstatus();

                string mailbody = "<html><head>";
                mailbody += "<style>";
                mailbody += "table, th, td {";
                mailbody += " border: 1px solid black;";

                mailbody += " }";
                mailbody += "th{background-color:yellow;text-align:center;color:black;}";
                mailbody += "td{text-align:center;color:black;}";
                mailbody += "</style>";
                mailbody += "</head>";

                mailbody += "<body>";

                sub = "All Backups of offline clients to our SQL server backup clients are OK";
                if (arrstatus[0].Count != 0)
                {
                    sub = "Some Backups of offline clients to our SQL server backup clients are not OK";
                    mailbody += "<strong style='color:red' >List of Backups not done in last 24 hours</strong> <br/><br/>";
                    mailbody += "<table style='border:1px solid;border-collapse:collapse;'><tr><th>Client Name</th><th>Last OPD Bill</th><th>Last IPD Discharge</th><th>Last AP_Restored</th><th>AP_Status</th><th>Last Lab</th><th>Last LAB_Restored</th><th>LAB_Status</th><th>Last PHARMACY_Bill</th><th>Last PHARMACY_Restored</th><th>PHARMACY_Status</th></tr>";
                    for (int j = 0; j < arrstatus[0].Count; j++)
                    {

                        cls_backup_track xx = arrstatus[0][j];
                        mailbody += "<tr><td style='background-color:darkred;color:white;'>" + xx.clientname + "</td><td>" + xx.ap_opd_bill + "</td><td>" + xx.ap_ipd_discharge + "</td><td>" + xx.ap_restored + "</td><td>" + xx.ap_staus + "</td><td>" + xx.lab_lastlab + "</td><td>" + xx.lab_restored + "</td><td>" + xx.lab_staus + "</td><td>" + xx.pharma_last_bill + "</td><td>" + xx.pharma_restored + "</td><td>" + xx.pharma_staus + "</td></tr>";
                    }
                    mailbody += "</table>";
                }
                mailbody += "<br/><br/><strong style='color:black;'>List of Backups done in last 24 hours</strong> <br/><br/>";
                mailbody += "<table style='border:1px solid;border-collapse:collapse;'><tr><th>Client Name</th><th>Last OPD Bill</th><th>Last IPD Discharge</th><th>Last AP_Restored</th><th>AP_Status</th><th>Last Lab</th><th>Last LAB_Restored</th><th>LAB_Status</th><th>Last PHARMACY_Bill</th><th>Last PHARMACY_Restored</th><th>PHARMACY_Status</th></tr>";
                for (int j = 0; j < arrstatus[1].Count; j++)
                {

                    cls_backup_track xx = arrstatus[1][j];
                    mailbody += "<tr><td style='background-color:darkgreen;color:white;'>" + xx.clientname + "</td><td>" + xx.ap_opd_bill + "</td><td>" + xx.ap_ipd_discharge + "</td><td>" + xx.ap_restored + "</td><td>" + xx.ap_staus + "</td><td>" + xx.lab_lastlab + "</td><td>" + xx.lab_restored + "</td><td>" + xx.lab_staus + "</td><td>" + xx.pharma_last_bill + "</td><td>" + xx.pharma_restored + "</td><td>" + xx.pharma_staus + "</td></tr>";
                }
                mailbody += "</table>";

                mailbody += "</body></html>";



                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;
                var baseAddress = "https://api.zeptomail.com/v1.1/email";

                var http = (HttpWebRequest)WebRequest.Create(new Uri(baseAddress));
                http.Accept = "application/json";
                http.ContentType = "application/json";
                http.Method = "POST";
                http.PreAuthenticate = true;
                http.Headers.Add("Authorization", "Zoho-enczapikey wSsVR6108xGkCPwrn2Ktdew9mlwBA1/zFxks0VGnv3etF/DGocc7kkObAQ6jGvQdQjU4Ejoa9eovkEgBh2UG2t0ly1pRCiiF9mqRe1U4J3x17qnvhDzKV2hVlhqLK4sNxApvmGJlEMoi+g==");
                clsZeptoEmail objemail = new clsZeptoEmail();
                objemail.to = new List<clszeptoemailaddrto>();


                objemail.to.Add(new clszeptoemailaddrto("support@acsonnet.com"));
                objemail.to.Add(new clszeptoemailaddrto("sales@acsonnet.com"));
                objemail.to.Add(new clszeptoemailaddrto("moizaccurate@gmail.com"));
                objemail.to.Add(new clszeptoemailaddrto("krishan_accurate@yahoo.co.in"));
                objemail.to.Add(new clszeptoemailaddrto("rajvashisth1978@yahoo.co.in"));
                //objemail.to.Add(new clszeptoemailaddrto("promitsindhu@gmail.com"));



                objemail.subject = sub;
                objemail.htmlbody = mailbody;



                //JObject parsedContent = JObject.Parse(objemail);
                //Console.WriteLine(parsedContent.ToString());
                ASCIIEncoding encoding = new ASCIIEncoding();

                string str1 = Newtonsoft.Json.JsonConvert.SerializeObject(objemail);
                Byte[] bytes = encoding.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(objemail));
                ///////Byte[] bytes = encoding.GetBytes("{ 'bounce_address':'bounce@bounce.acsonnet.com','from': { 'address': 'bounce@bounce.acsonnet.com'},'reply_to': [{'address': 'amitgupta.ais@gmail.com', name:'Amit Gupta from Zoho'}] ,'to': [{'email_address': {'address': 'support@acsonnet.com'}}],'subject':'Test Email','htmlbody':'<div><b> Test email sent successfully.  </b></div>'}");

                Stream newStream = http.GetRequestStream();
                newStream.Write(bytes, 0, bytes.Length);
                newStream.Close();

                var response = http.GetResponse();

                var stream = response.GetResponseStream();
                var sr = new StreamReader(stream);
                var content = sr.ReadToEnd();
                Console.WriteLine(content);




                
                objmsg.IsSaved = true;
                objmsg.SuccessMsg = "Mail Sent Successfully!!";

            }
            catch (Exception ex)
            {
                objmsg.IsSaved = false;
                
                objmsg.ErrorMsg = ex.Message;
            }
            

           



            return objmsg;
        }

        [WebMethod(EnableSession = true)]
        public Msg saveClientData(cls_backup_client obj)
        {
            Msg objmsg = new Msg();
            SqlConnection conn = null;
            SqlTransaction trans = null;
            try
            {
                conn.ConnectionString = "Data Source=192.168.1.100; User Id=a; Password=a; Initial Catalog=SimpleBillApplication; Integrated Security=false";
                conn.Open();
                trans = conn.BeginTransaction();

                ColumnDataCollection coll = new ColumnDataCollection();
                if (!Common.Unikey(obj.code, "CODE", "BackupClients", "", conn, trans))
                {
                    

                    coll.Add("CODE", Common.MyCStr(obj.code).Trim());
                    coll.Add("NAME", Common.MyCStr(obj.name).Trim());
                    coll.Add("Constr", Common.MyCStr(obj.connection_string).Trim());
                    coll.Add("ApDb", Common.MyCStr(obj.ap_db_name).Trim());
                    coll.Add("Aplabdb", Common.MyCStr(obj.aplab_db_name).Trim());
                    coll.Add("pharmadb", Common.MyCStr(obj.pharmacy_db_name).Trim());
                    Common.UpdateTable("BackupClients", coll, AisUpdateTableType.Update, "code='" + Common.MyCStr(obj.code).Trim() + "'", conn, trans);
                    //throw new Exception("User code " + obj.code + " already exists");
                }
                else
                {
                    coll = new ColumnDataCollection();

                    coll.Add("CODE", Common.MyCStr(obj.code).Trim());
                    coll.Add("NAME", Common.MyCStr(obj.name).Trim());
                    coll.Add("Constr", Common.MyCStr(obj.connection_string).Trim());
                    coll.Add("ApDb", Common.MyCStr(obj.ap_db_name).Trim());
                    coll.Add("Aplabdb", Common.MyCStr(obj.aplab_db_name).Trim());
                    coll.Add("pharmadb", Common.MyCStr(obj.pharmacy_db_name).Trim());
                    Common.UpdateTable("BackupClients", coll, AisUpdateTableType.Insert, " CODE='" + obj.code + "' ", conn, trans);
                }

                //if (Common.Unikey(obj.CODE, "CODE", "AP_COMPDEPT", "", conn, trans))
                //{
                //    throw new Exception("User code " + obj.CODE + " not exists and cannnot be modified ");
                //}


                


                Common.CommitTransaction(trans, "saveClientData");
                objmsg.IsSaved = true;
                objmsg.SuccessMsg = "Saved Successfully!!";

            }
            catch (Exception ex)
            {
                objmsg.IsSaved = false;
                Common.RollbackTransaction(trans, "saveClientData");
                objmsg.ErrorMsg = ex.Message;
            }
            finally
            {
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }

            //throw ex;



            return objmsg;
        }

        [WebMethod(EnableSession = true)]
        public List<cls_backup_client> getClients()
        {
            DbConnection conn = null;
            DbTransaction trans = null;
            List<cls_backup_client> arr = new List<cls_backup_client>();
            try
            {
                conn = Common.GetConnection();
                trans = Common.BeginTransaction(conn, "getClients");
                string qry = "select * from BackupClients";
                DataTable dt = Common.GetTable(qry, "BackupClients", conn, trans);
                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        cls_backup_client obj = new cls_backup_client();
                        obj.code = Common.MyCStr(dt.Rows[i]["code"]).Trim();
                        obj.name = Common.MyCStr(dt.Rows[i]["name"]).Trim();
                        obj.connection_string = Common.MyCStr(dt.Rows[i]["Constr"]).Trim();
                        obj.ap_db_name = Common.MyCStr(dt.Rows[i]["ApDb"]).Trim();
                        obj.aplab_db_name = Common.MyCStr(dt.Rows[i]["Aplabdb"]).Trim();
                        obj.pharmacy_db_name = Common.MyCStr(dt.Rows[i]["pharmadb"]).Trim();
                        arr.Add(obj);
                    }
                }
                Common.CommitTransaction(trans, "getClients");
            }
            catch
            {
                Common.RollbackTransaction(trans, "getClients");
            }
            finally
            {
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            return arr;
        }

        [WebMethod(EnableSession = true)]
        public cls_backup_client getClientData(string cc)
        {
            DbConnection conn = null;
            DbTransaction trans = null;
            cls_backup_client obj = new cls_backup_client();
            try
            {
                conn = Common.GetConnection();
                trans = Common.BeginTransaction(conn, "getClientData");
                string qry = "select * from BackupClients where code='" + cc + "'";
                DataTable dt = Common.GetTable(qry, "BackupClients", conn, trans);
                if (dt != null && dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        obj.code = Common.MyCStr(dt.Rows[i]["code"]).Trim();
                        obj.name = Common.MyCStr(dt.Rows[i]["name"]).Trim();
                        obj.connection_string = Common.MyCStr(dt.Rows[i]["Constr"]).Trim();
                        obj.ap_db_name = Common.MyCStr(dt.Rows[i]["ApDb"]).Trim();
                        obj.aplab_db_name = Common.MyCStr(dt.Rows[i]["Aplabdb"]).Trim();
                        obj.pharmacy_db_name = Common.MyCStr(dt.Rows[i]["pharmadb"]).Trim();

                    }
                }
                Common.CommitTransaction(trans, "getClients");
            }
            catch
            {
                Common.RollbackTransaction(trans, "getClients");
            }
            finally
            {
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            return obj;
        }

        public class cls_backup_track
        {
            public string clientname;
            public string ap_opd_bill;
            public string ap_ipd_discharge;
            public string ap_restored;
            public string ap_staus;
            public string lab_lastlab;
            public string lab_restored;
            public string lab_staus;
            public string pharma_last_bill;
            public string pharma_restored;
            public string pharma_staus;
        }

        [WebMethod(EnableSession = true)]
        public List<List<cls_backup_track>> getbackupstatus()
         {

            List<List<cls_backup_track>> ans = new List<List<cls_backup_track>>();
            List<cls_backup_track> mainarr= new List<cls_backup_track>();
            List<cls_backup_track> errorarr = new List<cls_backup_track>();
 
            DbConnection newconn = null;
            newconn = Common.GetConnection();

            
            string str = "select * from BackupClients";

            DataTable dt1 = Common.GetTable(str, "BackupClients");

            if(dt1!=null && dt1.Rows.Count > 0)
            {
                for(int i = 0; i < dt1.Rows.Count; i++)
                {
                    
                    DbConnection conn = null;
                    cls_backup_track obj = new cls_backup_track();
                    obj.clientname = Common.MyCStr(dt1.Rows[i]["name"]).Trim();

                    
                    try
                    {
                        bool error = false;
                        bool lab_error = false;
                        bool pharmacy_error = false;
                        string ConnectionString = "Data Source=" + Common.MyCStr(dt1.Rows[i]["Constr"]).Trim() + "; User Id=ap; Password=dfcnkbd78378hn; Initial Catalog=master; Integrated Security=false";
                        conn = Common.GetConnectionusingConnectionString(ConnectionString);
                        DataTable dt = new DataTable();
                        string ap_dbname = Common.MyCStr(dt1.Rows[i]["ApDb"]).Trim();
                        if (Common.MyLen(ap_dbname) > 0)
                        {
                            str = "SELECT DB_NAME() AS DatabaseName, DATABASEPROPERTYEX('" + ap_dbname + "', 'Status') AS DBStatus";
                            dt = Common.GetTable(str, "ss", conn,null);
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                if (Common.MyCStr(dt.Rows[0]["DBStatus"]) == "ONLINE") 
                                {
                                    obj.ap_staus = "OK"; /*Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim();*/
                                }
                                else
                                {
                                    error = true;
                                    obj.ap_staus = "NOT OK (" + Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim() + ")";/*Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim();*/
                                }
                            }
                            
                                str = "select last_restored_date from msdb..log_shipping_secondary_databases where secondary_database = '" + ap_dbname + "'";
                                dt = Common.GetTable(str,"ss",conn,null);
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    DateTime curr = Common.GetServerDate();
                                    DateTime lastrestored = Common.MyCDate(dt.Rows[0]["last_restored_date"]);
                                    TimeSpan ts = curr - lastrestored;
                                    if (Common.MycInt(ts.TotalHours) > 24)
                                    {
                                        error = true;
                                        obj.ap_staus = "NOT OK";
                                    }
                                    obj.ap_restored = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["last_restored_date"]), "dd/MMM/yyyy hh:mm tt");
                                }
                            if (!error)
                            {
                                str = "select max(bdate)bdate from " + ap_dbname + "..bills where typ in ('O', 'G') and(ENTRYTYPE is null or entrytype = 0)";
                                try
                                {
                                    dt = Common.GetTable(str, "ss", conn, null);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        obj.ap_opd_bill = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["bdate"]), "dd/MMM/yyyy hh:mm tt");
                                    }
                                }
                                catch(Exception ex)
                                {
                                    error = true;
                                    obj.ap_staus = "NOT OK";
                                    obj.ap_opd_bill = ex.ToString();
                                }

                                str = "select max(disdate)disdate from " + ap_dbname + "..bills where typ in ('I') and discharge = 'Y' and(ENTRYTYPE is null or entrytype = 0)";
                                try
                                {
                                    dt = Common.GetTable(str, "ss", conn, null);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        obj.ap_ipd_discharge = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["disdate"]), "dd/MMM/yyyy hh:mm tt");
                                    }
                                }
                                catch(Exception ex)
                                {
                                    error = true;
                                    obj.ap_staus = "NOT OK";
                                    obj.ap_ipd_discharge = ex.ToString();
                                }
                            }
                        }

                        string lab_dbname = Common.MyCStr(dt1.Rows[i]["Aplabdb"]).Trim();
                        if (Common.MyLen(lab_dbname) > 0)
                        {
                            str = "SELECT DB_NAME() AS DatabaseName, DATABASEPROPERTYEX('" + lab_dbname + "', 'Status') AS DBStatus";
                            dt = Common.GetTable(str, "ss", conn, null);
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                if (Common.MyCStr(dt.Rows[0]["DBStatus"]) == "ONLINE")
                                {
                                    obj.lab_staus = "OK"; /*Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim();*/
                                }
                                else
                                {
                                    lab_error = true;
                                    //error = true;
                                    obj.lab_staus = "NOT OK (" + Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim() + ")"; /*Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim();*/
                                }
                            }

                            
                                str = "select last_restored_date from msdb..log_shipping_secondary_databases where secondary_database = '" + lab_dbname + "'";
                                dt = Common.GetTable(str, "ss", conn, null);
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    DateTime curr = Common.GetServerDate();
                                    DateTime lastrestored = Common.MyCDate(dt.Rows[0]["last_restored_date"]);
                                    TimeSpan ts = curr - lastrestored;
                                    if (Common.MycInt(ts.TotalHours) > 24)
                                    {
                                        lab_error = true;
                                        //error = true;
                                        obj.lab_staus = "NOT OK";
                                    }
                                    obj.lab_restored = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["last_restored_date"]), "dd/MMM/yyyy hh:mm tt");
                                }
                            if (!lab_error )
                            {
                                str = "select max(tdate)tdate from " + lab_dbname + "..labm";
                                try
                                {
                                    dt = Common.GetTable(str, "ss", conn, null);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        obj.lab_lastlab = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["tdate"]), "dd/MMM/yyyy hh:mm tt");
                                    }
                                }
                                catch (Exception ex)
                                {
                                    lab_error = true;
                                    //error = true;
                                    obj.lab_staus = "NOT OK";
                                    obj.lab_lastlab = ex.ToString();
                                }
                            }
                        }

                        string pharmacy_dbname = Common.MyCStr(dt1.Rows[i]["pharmadb"]).Trim();
                        if (Common.MyLen(pharmacy_dbname) > 0)
                        {
                            str = "SELECT DB_NAME() AS DatabaseName, DATABASEPROPERTYEX('" + pharmacy_dbname + "', 'Status') AS DBStatus";
                            dt = Common.GetTable(str, "ss", conn, null);
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                if (Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim() == "ONLINE")
                                {
                                    obj.pharma_staus = "OK";
                                }
                                else
                                {
                                    pharmacy_error = true;
                                    //error = true;
                                    obj.pharma_staus = "NOT OK (" + Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim() + ")"; /*Common.MyCStr(dt.Rows[0]["DBStatus"]).Trim();*/
                                }

                            }

                            
                                str = " select last_restored_date from msdb..log_shipping_secondary_databases where secondary_database = '" + pharmacy_dbname + "'";
                                dt = Common.GetTable(str, "ss", conn, null);
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    DateTime curr = Common.GetServerDate();
                                    DateTime lastrestored = Common.MyCDate(dt.Rows[0]["last_restored_date"]);
                                    TimeSpan ts = curr - lastrestored;
                                    if (Common.MycInt(ts.TotalHours) > 24)
                                    {
                                        pharmacy_error = true;
                                        //error = true;
                                        obj.pharma_staus = "NOT OK";
                                    }
                                    obj.pharma_restored = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["last_restored_date"]), "dd/MMM/yyyy hh:mm tt");
                                }
                            if (!pharmacy_error)
                            {
                                str = "select max(idate)idate from " + pharmacy_dbname + "..erp_store_bill  where tc in ('CS','RS')";
                                try
                                {
                                    dt = Common.GetTable(str, "ss", conn, null);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        obj.pharma_last_bill = Common.GetPrintDate(Common.MyCDate(dt.Rows[0]["idate"]), "dd/MMM/yyyy hh:mm tt");
                                    }
                                }
                                catch (Exception ex)
                                {
                                    pharmacy_error = true;
                                    //error = true;
                                    obj.pharma_staus = "NOT OK";
                                    obj.pharma_last_bill = ex.ToString();
                                }
                            }
                        }
                        if (error || lab_error || pharmacy_error)
                        {
                            errorarr.Add(obj);
                        }
                        else
                        {
                            mainarr.Add(obj);
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                    finally
                    {
                        if (conn != null && conn.State == System.Data.ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }
                }
                ans.Add(errorarr);
                ans.Add(mainarr);

            }
       
            newconn.Close();
            
            return ans;
        }
       








    }
}
