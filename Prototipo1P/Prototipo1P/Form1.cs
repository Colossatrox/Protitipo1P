using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Odbc;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Prototipo1P
{
    public partial class Form1 : Form
    {
        clsConexion con = new clsConexion();
        int codigo;
        public Form1()
        {
            InitializeComponent();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

            for (int i = 1000; i >= 0; i--)
            {
                domainUpDown1.Items.Add(i);
            }
            domainUpDown1.SelectedIndex = 999;
            try
            {
                string Query = "SELECT * FROM PROVEEDOR WHERE ESTATUS=1";
                OdbcDataReader Datos;
                OdbcCommand Consulta = new OdbcCommand();
                Consulta.CommandText = Query;
                Consulta.Connection = con.Conexion();
                Datos = Consulta.ExecuteReader();
                while (Datos.Read())
                {
                    cmbIdProv.Items.Add(Datos.GetString(0));
                    cmbProv.Items.Add(Datos.GetString(1) + " " + Datos.GetString(2));
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                throw;
            }
            try
            {
                string Query = "SELECT * FROM EMPLEADO WHERE ESTATUS=1";
                OdbcDataReader Datos;
                OdbcCommand Consulta = new OdbcCommand();
                Consulta.CommandText = Query;
                Consulta.Connection = con.Conexion();
                Datos = Consulta.ExecuteReader();
                while (Datos.Read())
                {
                    comboBox1.Items.Add(Datos.GetString(0));
                    comboBox2.Items.Add(Datos.GetString(1) + " " + Datos.GetString(2));
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                throw;
            }
            codigo = 1;
            try
            {
                //consulta para obtener el codigo máximo en la tabla de factura encabezado
                string consulta = "SELECT MAX(IDCOMPRA) FROM COMPRAENCABEZADO ";
                OdbcCommand comm = new OdbcCommand(consulta, con.Conexion());
                OdbcDataReader codFacturaEnc = comm.ExecuteReader();
                if (codFacturaEnc.Read())
                {
                    //se suma 1 al código obtenido
                    codigo = codFacturaEnc.GetInt32(0) + 1;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }

        }

        private void cmbProv_SelectedIndexChanged(object sender, EventArgs e)
        {
            cmbIdProv.SelectedIndex = cmbProv.SelectedIndex;
            cmbidproducto.Items.Clear();
            cmbproducto.Items.Clear();
            try
            {
                string Query = "SELECT PROD.IDPRODUCTO, PROD.NOMBRE FROM PRODUCTO PROD, PRODUCTOPROVEEDOR PRODPROV WHERE PRODPROV.IDPROD=PROD.IDPRODUCTO AND PRODPROV.IDPROV= " + int.Parse(cmbIdProv.SelectedItem.ToString());
                OdbcDataReader Datos;
                OdbcCommand Consulta = new OdbcCommand();
                Consulta.CommandText = Query;
                Consulta.Connection = con.Conexion();
                Datos = Consulta.ExecuteReader();
                while (Datos.Read())
                {
                    cmbidproducto.Items.Add(Datos.GetString(0));
                    cmbproducto.Items.Add(Datos.GetString(1));
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                throw;
            }
            cmbProv.Enabled = false;
        }

        private void cmbproducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            cmbidproducto.SelectedIndex = cmbproducto.SelectedIndex;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                string Query = "SELECT * FROM PRODUCTO WHERE IDPRODUCTO=" + int.Parse(cmbidproducto.SelectedItem.ToString());
                OdbcDataReader Datos;
                OdbcCommand Consulta = new OdbcCommand();
                Consulta.CommandText = Query;
                Consulta.Connection = con.Conexion();
                Datos = Consulta.ExecuteReader();
                while (Datos.Read())
                {
                    dataGridView1.Rows.Add(Datos.GetValue(1), Datos.GetValue(2), Datos.GetDouble(3), domainUpDown1.SelectedItem.ToString(), Datos.GetDouble(3) * int.Parse(domainUpDown1.SelectedItem.ToString()), Datos.GetValue(0));
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
                throw;
            }
            double sum = 0;
            for (int i = 0; i < dataGridView1.Rows.Count; ++i)
            {
                sum += Convert.ToDouble(dataGridView1.Rows[i].Cells[4].Value);
            }
            label5.Text = sum.ToString();
        }

        private void button2_Click(object sender, EventArgs e)
        {

            DateTime fechaActual = DateTime.Now;
            string fecha = fechaActual.ToString("yyyy-MM-dd");
            try
            {

                string insertarEncabezado = "INSERT INTO COMPRAENCABEZADO (IDCOMPRA,IDEMP,FECHAREALIZADA,PAGO,IDPROV,ESTATUS) " +
                    "VALUES(" + codigo + ",'" + int.Parse(comboBox1.SelectedItem.ToString()) + "',?, 0 ," + int.Parse(cmbIdProv.Text.ToString()) + ",1)";
                OdbcCommand comm = new OdbcCommand(insertarEncabezado, con.Conexion());
                comm.Parameters.Add("@FECHA", OdbcType.Date).Value = fecha;
                comm.ExecuteNonQuery();
                for (int i = 0; i < dataGridView1.Rows.Count - 1; i++)
                {
                    try
                    {
                        string insertarDetalle = "INSERT INTO COMPRADETALLE (IDCOMPRA,IDPRODUCTO,CANTIDAD) " +
                            "VALUES ( " + codigo + ", " + Convert.ToInt32(dataGridView1.Rows[i].Cells[5].Value) + "," + Convert.ToInt32(dataGridView1.Rows[i].Cells[3].Value) + ")";
                        OdbcCommand comm2 = new OdbcCommand(insertarDetalle, con.Conexion());
                        comm2.ExecuteNonQuery();
                    }
                    catch (Exception ex2)
                    {
                        MessageBox.Show(ex2.ToString());
                    }
                }
                MessageBox.Show("Compra guardada con exito");

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            dataGridView1.Rows.Clear();
            comboBox2.SelectedIndex = 0;
            cmbProv.SelectedIndex = 0;
            cmbproducto.SelectedIndex = 0;
            cmbProv.Enabled = true;
            domainUpDown1.SelectedIndex = 999;
            label3.Text = "0.00";

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            comboBox1.SelectedIndex = comboBox2.SelectedIndex;
        }

        
    }
}
