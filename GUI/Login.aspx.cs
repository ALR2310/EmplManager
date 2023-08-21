using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Oauth2.v2;
using Google.Apis.Oauth2.v2.Data;
using BUS;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.Net.Http.Headers;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Auth.OAuth2.Responses;
using DAL;
using System.Text.Json;
using System.Configuration;

namespace GUI
{
    public partial class Login : System.Web.UI.Page
    {
        string clientId = "719235217594-7e1ebl1qrbnt16k24nsku5m2ccr89dcp.apps.googleusercontent.com";
        string clientSecret = "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";
        //string redirectUri = "https://projectctysf.com/dang-nhap";

        string redirectUri;


        //string clientId = Environment.GetEnvironmentVariable("googleClientId");
        //string clientSecret = Environment.GetEnvironmentVariable("googleClientSecret");
        //string redirectUri = Environment.GetEnvironmentVariable("googleRedirectUri");



        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.Url.Host == "localhost")
            {
                redirectUri = "https://localhost:44369/dang-nhap";
            }
            else if (HttpContext.Current.Request.Url.Host == "projectctysf.com")
            {
                redirectUri = "https://projectctysf.com/dang-nhap";
            }

            //tblclientId.Text = clientId;
            //tblclientSecret.Text = clientSecret;
            //tblredirectUri.Text = redirectUri;

            Debug.WriteLine(JsonSerializer.Serialize(Environment.GetEnvironmentVariables().Keys));
            Debug.WriteLine("Client ID: " + clientId);
            Debug.WriteLine("Client Secret: " + clientSecret);
            Debug.WriteLine("redirectUri: " + redirectUri);
            {
                int? validcookie = UserManager.checkValidCookie(Request);
                Debug.WriteLine(validcookie);
                if (validcookie != null)
                {
                    string script = "this.location = \"./tin-nhan\";";

                    ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
                }
            }

            if (!IsPostBack && Request.QueryString["code"] != null)
            {
                HttpCookie authCookie;
                string authTokenStr;
                string code = Request.QueryString["code"];

                GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
                {
                    ClientSecrets = new ClientSecrets
                    {
                        ClientId = clientId,
                        ClientSecret = clientSecret
                    },
                    Scopes = new[] { "email", "profile" }
                });

                TokenResponse token = flow.ExchangeCodeForTokenAsync("", code, redirectUri, System.Threading.CancellationToken.None).Result;

                if (token != null)
                {
                    // Use token.AccessToken to access Google APIs and retrieve user information.
                    var oauth2Service = new Oauth2Service(new Google.Apis.Services.BaseClientService.Initializer { HttpClientInitializer = new UserCredential(flow, "", token) });
                    var userInfo = oauth2Service.Userinfo.Get().Execute();

                    string googleUserId = userInfo.Id;
                    string googleEmail = userInfo.Email;
                    string googleName = userInfo.Name;
                    string googlePictureUrl = userInfo.Picture;

                    if (UserManager.GoogleIdIsExists(googleUserId).Count == 0)
                    {
                        User ExistUser = UserManager.GetUserByEmail(googleEmail);
                        if (ExistUser != null)
                        {
                            InlineQuery query = new InlineQuery();
                            query.Execute($"update dbo.Users set GoogleId = '{googleUserId}' where  email = '{googleEmail}'");
                            authTokenStr = UserManager.Login(ExistUser.UserName, ExistUser.Password);

                            authCookie = new HttpCookie("AuthToken", authTokenStr);
                            authCookie.Expires = DateTime.Now.AddDays(7);

                            Response.Cookies.Add(authCookie);

                            ToastManager.SuccessToast("Đăng nhập thành công! Chuẩn bị chuyển hướng trong vài giây...");

                            Response.Redirect("Message.aspx");

                            return;
                        }


                        //Nếu ggId chưa tồn tại thì tạo users mới và đăng nhập
                        User user = new User
                        {
                            GoogleId = googleUserId,
                            Avatar = googlePictureUrl,
                            Email = googleEmail,
                            DisplayName = googleName,
                            UserType = 1,
                            Status = 1
                        };
                        //save
                        UserManager.InsertUsers(user);
                    }


                    authTokenStr = UserManager.getOrSetAuthTokenFromNewGoogleAccount(googleEmail, googleUserId);

                    authCookie = new HttpCookie("AuthToken", authTokenStr);
                    authCookie.Expires = DateTime.Now.AddDays(7);
                    Debug.Write(authCookie);
                    Response.Cookies.Add(authCookie);

                    ToastManager.SuccessToast("Đăng nhập thành công! Chuẩn bị chuyển hướng trong vài giây...");

                    Response.Redirect("tin-nhan");

                }
            }
        }

        protected void LoginWithGoogle_ServerClick(object sender, EventArgs e)
        {


            string scope = "email profile";

            string authorizationUrl = string.Format("https://accounts.google.com/o/oauth2/auth?client_id={0}&redirect_uri={1}&scope={2}&response_type=code", clientId, redirectUri, scope);

            Response.Redirect(authorizationUrl);
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                string userName = txtUserName.Text;
                string password = txtPassword.Text;

                String authToken = UserManager.Login(userName, password);

                HttpCookie authCookie = new HttpCookie("AuthToken", authToken);
                authCookie.Expires = DateTime.Now.AddDays(7);
                Response.Cookies.Add(authCookie);

                if (authToken != "_failed_")
                {
                    string script = "toggleModal()";
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "my", script, true);

                    script = "setTimeout(function(){this.location = \"./tin-nhan\"},1500)";
                    ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
                    return;
                }
                ToastManager.ErrorToast("Đăng nhập không thành công.. Sai Mật Khẩu hoặc Tên Đăng Nhập / Email");

            }
        }
    }
}