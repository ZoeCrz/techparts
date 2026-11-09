using System;
using System.Web;
using MySql.Data.MySqlClient;

namespace wssTechParts2._0
{
    internal static class AccessGuard
    {
        public static int CurrentUser()
        {
            int id;
            var session = HttpContext.Current == null ? null : HttpContext.Current.Session;
            if (session == null || !int.TryParse(Convert.ToString(session["cveUsuario"]), out id) || id <= 0)
                throw new HttpException(401, "Inicia sesión.");
            return id;
        }
        public static bool IsAdmin()
        {
            return HttpContext.Current != null && HttpContext.Current.Session != null &&
                string.Equals(Convert.ToString(HttpContext.Current.Session["Rol"]), "ADMINISTRADOR", StringComparison.OrdinalIgnoreCase);
        }
        public static void User(int id)
        {
            if (CurrentUser() != id && !IsAdmin()) throw new HttpException(403, "Usuario no autorizado.");
        }
        public static void Sale(string connectionString, int id)
        {
            int user = CurrentUser();
            using (var connection = new MySqlConnection(connectionString))
            using (var command = new MySqlCommand("SELECT USU_Clave FROM TEC_PEDIDO WHERE PED_Clave=@id", connection))
            {
                command.Parameters.AddWithValue("@id", id);
                connection.Open();
                object owner = command.ExecuteScalar();
                if (owner == null || (Convert.ToInt32(owner) != user && !IsAdmin()))
                    throw new HttpException(403, "Pedido no autorizado.");
            }
        }
    }
}
