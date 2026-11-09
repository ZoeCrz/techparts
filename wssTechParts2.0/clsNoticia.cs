using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace wssTechParts2._0
{
    public class clsNoticia
    {
        // PERMITE ADMINISTRAR LA CADENA DE ADMINISTRACIÓN A LA BD
        public MySqlConnection cnn;
        // EJECUTAR UN COMANDO DE MYSQL
        public MySqlCommand cmd;
        // RECIBE VARIOS REGISTROS QUE VAN A UN SOLO CONTROL O UNA VARIABLE
        public MySqlDataAdapter da;
        // RECIBE VARIOS REGISTROS QUE PUEDEN IR A DIFERENTES CONTROLES O VARIAS VARIABLES
        public MySqlDataReader dr;
        // RECIBE EL RESULTADO DE MUCHOS REGISTROS SIN TIPEARSE, ES DECIR SIN FORMATO
        public DataSet ds;
        // Listar para el Grid
        public DataSet listarNoticiasGestion(string cadConexion)
        {
            MySqlDataAdapter da = SqlProcedure.Adapter(cadConexion, "spListarNoticiasGestion");
            DataSet ds = new DataSet();
            da.Fill(ds, "Noticias");
            return ds;
        }

        // Buscar para editar
        public DataSet buscarNoticia(string cadConexion, int clave)
        {
            MySqlDataAdapter da = SqlProcedure.Adapter(cadConexion, "spBuscarNoticia", clave);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }
        // Agregar
        public DataSet agregarNoticia(string cadConexion, string titulo, string contenido, string imagen, string url)
        {
            MySqlConnection cnn = new MySqlConnection(cadConexion);
            MySqlDataAdapter da = SqlProcedure.Adapter(cnn, "spAgregarNoticia", titulo, contenido, imagen, url);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }
        // Actualizar
        public DataSet actualizarNoticia(string cadConexion, int clave, string titulo, string contenido, string imagen, string url)
        {
            MySqlConnection cnn = new MySqlConnection(cadConexion);
            MySqlDataAdapter da = SqlProcedure.Adapter(cnn, "spActualizarNoticia", clave, titulo, contenido, imagen, url);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }
        // Eliminar
        public int eliminarNoticia(string cadConexion, int clave)
        {
            MySqlConnection cnn = new MySqlConnection(cadConexion);
            MySqlCommand cmd = SqlProcedure.Command(cnn, "spEliminarNoticia", clave);
            cnn.Open();
            int res = Convert.ToInt32(cmd.ExecuteScalar());
            cnn.Close();
            return res;
        }
    }
}
