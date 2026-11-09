// Manejar todos los registros que llegan MySQL
using MySql.Data;
// Ejecutar las instrucciones de mysql como sp
using MySql.Data.MySqlClient;
using System;
// SE USA PARA EL ARRAYLIST
using System.Collections;
using System.Collections.Generic;
// 1. Agregar las librerías que permitan manejar instrucciones de MySQL que maneja cualquier origen de datos
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace wssTechParts2._0
{
    public class clsUsuario
    {
        // 2. Atributos de la clase
        string usuario;
        string contra;
        string nomUsuario;
        string rol;
        int clave;
        string nombre;
        string apPat;
        string apMat;
        string email;
        string telefono;
        string calle;
        string numero;
        string colonia;
        string ciudad;
        string municipio;
        string estado;
        int cp;
        string foto;
        string estatus;

        // 3. Variables de la clase que permitirán trabajar con los datos de MySQL
        // PERMITE USAR LA CADENA DE CONEXIÓN
        public MySqlConnection cnn;
        // EJECUTAR LOS COMANDOS DE LA BASE DE DATOS: INSTRUCCIONES
        public MySqlCommand cmd;
        // RECIBE RESULTADOS DE UNA CONSULTA, INSERSION, MODIFICACIÓN O BORRADO PERO SUS DATOS VAN A UN SOLO CONTROL
        public MySqlDataAdapter da;
        // RECIBE LOS MISMOS QUE EL ADAPTER, PERO SUS DATOS PUEDEN COLOCARSE EN DIFERENTES CONTROLES
        public MySqlDataReader dr;
        // RECIBE UN CONJUNTO DE REGISTROS, PERO NO TIPEADOS
        public DataSet ds;

        // 4. Propiedades de lectura y escritura
        public string Usuario { get => usuario; set => usuario = value; }
        public string Contra { get => contra; set => contra = value; }
        public string NomUsuario { get => nomUsuario; set => nomUsuario = value; }
        public string Rol { get => rol; set => rol = value; }
        public int Clave { get => clave; set => clave = value; }
        public string Nombre { get => nombre; set => nombre = value; }
        public string ApPat { get => apPat; set => apPat = value; }
        public string ApMat { get => apMat; set => apMat = value; }
        public string Email { get => email; set => email = value; }
        public string Telefono { get => telefono; set => telefono = value; }
        public string Calle { get => calle; set => calle = value; }
        public string Numero { get => numero; set => numero = value; }
        public string Colonia { get => colonia; set => colonia = value; }
        public string Ciudad { get => ciudad; set => ciudad = value; }
        public string Municipio { get => municipio; set => municipio = value; }
        public string Estado { get => estado; set => estado = value; }
        public int CP { get => cp; set => cp = value; }
        public string Foto { get => foto; set => foto = value; }
        public string Estatus { get => estatus; set => estatus = value; }

        // 5. Contructor y destructor de la clase
        public clsUsuario()
        {
            clave = 0;
            nomUsuario = "";
            rol = "";
            usuario = "";
            contra = "";
            nombre = "";
            apPat = "";
            apMat = "";
            email = "";
            telefono = "";
            calle = "";
            numero = "";
            colonia = "";
            ciudad = "";
            municipio = "";
            estado = "";
            cp = 0;
            foto = "";
            estatus = "";
        }

        // 6. Métodos de la clase
        // VALIDAR ACCESO: tspValidarAcceso(usu, contr) --> 0 ó clave, nombre, rol
        public void validarAcceso(string cadConexion)
        {
            clave = 0;
            nomUsuario = rol = "";
            using (var connection = new MySqlConnection(cadConexion))
            using (var command = SqlProcedure.Command(connection, "spCredencialesAcceso", Usuario))
            {
                connection.Open();
                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read() && PasswordSecurity.Verify(Contra, Convert.ToString(reader["PasswordHash"])))
                    {
                        clave = Convert.ToInt32(reader["Clave"]);
                        nomUsuario = Convert.ToString(reader["Usuario"]);
                        rol = Convert.ToString(reader["Rol"]);
                    }
                }
            }
        }

        // LISTA DE USUARIOS
        public DataSet listarUsuarios(String cadConexion, int op, int clave)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarUsuarios", op, clave);
            ds = new DataSet();
            da.Fill(ds, "Usuarios");
            return ds;
        }

        // ACTUALIZAR INFORMACIÓN DEL USUARIO
        public DataSet actualizarInformacionUsuario(String cadConexion, int claveUsuario, int rol,
        string nombre, string apPat, string apMat, string email, string telefono,
        string calle, string numero, string colonia, string ciudad, string municipio,
        string estado, int cp, string foto, string usuario, string contra)
            {
                AccessGuard.User(claveUsuario);
                // Only administrators can change roles. A customer always keeps role 2.
                if (!AccessGuard.IsAdmin()) rol = 2;
                string passwordHash = string.IsNullOrEmpty(contra) ? "" : PasswordSecurity.Hash(contra);
                da = SqlProcedure.Adapter(cadConexion, "spActualizarInformacionUsuario", claveUsuario, rol, nombre, apPat, apMat, email, telefono, calle, numero, colonia, ciudad, municipio, estado, cp, foto, usuario, passwordHash);
                ds = new DataSet();
                da.Fill(ds, "Usuario");
                return ds;
            }

        public DataSet buscarUsuario(string cadConexion, int claveUsu)
        {
            AccessGuard.User(claveUsu);
            MySqlConnection cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            MySqlCommand cmd = new MySqlCommand();

            // CORREGIDO: El nombre del procedimiento es "spBuscarUsuario" no "tspBuscarUsuario"
            SqlProcedure.Configure(cmd, "spBuscarUsuario", claveUsu);
            cmd.Connection = cnn;

            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds, "usuarioEncontrado");

            // Puebla las propiedades del objeto si el usuario se encuentra
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];

                // Validar que tenemos todas las columnas esperadas antes de acceder a ellas
                if (ds.Tables[0].Columns.Count >= 19)
                {
                    clave = int.Parse(dr[0].ToString());           // Clave (índice 0)
                    rol = dr[1].ToString();                        // Rol (índice 1)
                    nomUsuario = dr[2].ToString();                 // Nombre (índice 2)
                    apPat = dr[3].ToString();                      // ApPat (índice 3)
                    apMat = dr[4].ToString();                      // ApMat (índice 4)
                    email = dr[5].ToString();                      // Email (índice 5)
                    telefono = dr[6].ToString();                   // Telefono (índice 6)
                    calle = dr[7].ToString();                      // Calle (índice 7)
                    numero = dr[8].ToString();                     // Numero (índice 8)
                    colonia = dr[9].ToString();                    // Colonia (índice 9)
                    ciudad = dr[10].ToString();                    // Ciudad (índice 10)
                    municipio = dr[11].ToString();                 // Municipio (índice 11)
                    estado = dr[12].ToString();                    // Estado (índice 12)
                    CP = int.Parse(dr[13].ToString());             // CP (índice 13)
                    foto = dr[14].ToString();                      // Foto (índice 14)
                    usuario = dr[15].ToString();                   // Usuario (índice 15)
                    contra = "";                    // Contrasena (índice 16)
                    estatus = dr[17].ToString();                   // dr[17] = Estatus ("ACTIVO" o "INACTIVO")
                                                                   // dr[18] = Fecha (formato: "22 November 2025")
                }
                else
                {
                    // Usuario no encontrado - reiniciar propiedades a valores por defecto
                    clave = 0;
                    rol = "";
                    nomUsuario = "";
                    apPat = "";
                    apMat = "";
                    email = "";
                    telefono = "";
                    calle = "";
                    numero = "";
                    colonia = "";
                    ciudad = "";
                    municipio = "";
                    estado = "";
                    CP = 0;
                    foto = "";
                    usuario = "";
                    contra = "";
                }
            }

            cnn.Close();
            return ds;
        }
        public DataSet agregarUsuario(string cadConexion, int rol, string nombre, string apPat, string apMat,
        string email, string telefono, string calle, string numero, string colonia, string ciudad,
        string municipio, string estado, int cp, string foto, string usuario, string contrasena)
            {
                if (!AccessGuard.IsAdmin()) rol = 2;
                string passwordHash = PasswordSecurity.Hash(contrasena);
                da = SqlProcedure.Adapter(cadConexion, "spAgregarUsuario", rol, nombre, apPat, apMat, email, telefono, calle, numero, colonia, ciudad, municipio, estado, cp, foto, usuario, passwordHash);
                ds = new DataSet();
                da.Fill(ds, "Usuario");
                return ds;
            }

        /// <summary>
        /// Valida si un usuario o correo ya existen en la base de datos
        /// </summary>
        /// <param name="cadConexion">Cadena de conexión a la base de datos</param>
        /// <param name="usuario">Nombre de usuario a validar</param>
        /// <param name="email">Correo a validar</param>
        /// <returns>Retorna 0 si está disponible, 1 si el usuario existe, 2 si el email existe, 3 si ambos existen</returns>
        public int validarUsuarioYEmail(string cadConexion, string usuario, string email)
        {
            try
            {
                MySqlConnection cnn = new MySqlConnection(cadConexion);
                MySqlCommand cmd = new MySqlCommand();

                // Verificar si el usuario o email ya existen
                cmd.CommandText = "SELECT CASE WHEN EXISTS(SELECT 1 FROM TEC_USUARIO WHERE USU_Usuario = @usuario) " +
                                 "AND EXISTS(SELECT 1 FROM TEC_USUARIO WHERE USU_Email = @email) THEN 3 " +
                                 "WHEN EXISTS(SELECT 1 FROM TEC_USUARIO WHERE USU_Usuario = @usuario) THEN 1 " +
                                 "WHEN EXISTS(SELECT 1 FROM TEC_USUARIO WHERE USU_Email = @email) THEN 2 " +
                                 "ELSE 0 END;";
                
                cmd.Parameters.AddWithValue("@usuario", usuario ?? "");
                cmd.Parameters.AddWithValue("@email", email ?? "");
                cmd.Connection = cnn;

                cnn.Open();
                object resultado = cmd.ExecuteScalar();
                cnn.Close();

                return resultado != null ? int.Parse(resultado.ToString()) : 0;
            }
            catch (Exception ex)
            {
                // Si hay error, retornar 0 para permitir que el procedimiento almacenado maneje la validación
                System.Diagnostics.Debug.WriteLine("Error en validarUsuarioYEmail: " + "No se pudo completar la operación.");
                return 0;
            }
        }
        public DataSet listarRoles(string cadConexion)
        {
            da = SqlProcedure.Adapter(cadConexion, "spListarRoles");
            ds = new DataSet();
            da.Fill(ds, "Roles");
            return ds;
        }
        public int eliminarUsuario(string cadConexion, int clave)
        {
            int resultado = 0;
            cnn = new MySqlConnection();
            cnn.ConnectionString = cadConexion;
            cmd = new MySqlCommand();
            SqlProcedure.Configure(cmd, "spEliminarUsuario", clave);
            cmd.Connection = cnn;
            cnn.Open();
            dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                resultado = int.Parse(dr.GetValue(0).ToString());
            }
            dr.Close();
            cnn.Close();
            return resultado;
        }

        // Obtener la dirección formateada usando spBuscarUsuario
        public string obtenerDireccionCliente(string cadConexion, int idUsuario)
        {
            string direccion = "Sin dirección registrada"; // Valor por defecto
            MySqlDataAdapter da = SqlProcedure.Adapter(cadConexion, "spBuscarUsuario", idUsuario);
            DataTable dt = new DataTable();
            try
            {
                da.Fill(dt);

                // Verificamos si trajo datos y si existe la columna "DirEnvio"
                if (dt.Rows.Count > 0 && dt.Columns.Contains("DirEnvio"))
                {
                    // Tomamos el valor de la primera fila, columna "DirEnvio"
                    direccion = dt.Rows[0]["DirEnvio"].ToString();
                }
            }
            catch
            {
                direccion = "Error al obtener dirección";
            }
            return direccion;
        }
    }
}
