/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JInternalFrame.java to edit this template
 */
package loginsia;

import com.academico.login.conexion.SQLConnection;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.plaf.basic.BasicInternalFrameUI;
import javax.swing.table.DefaultTableModel;
import static loginsia.SIA.Ventana;

/**
 *
 * @author HUERTAS
 */
public class GruAsigBuscador extends javax.swing.JInternalFrame {

    private String asi_codigo;
    private String usuario;
    private String contrasena;
    private DefaultTableModel asig;
    private DefaultTableModel pre;
    SQLConnection cc = new SQLConnection();
    private Connection conexion;
    private String programa;
    private String tipologia;
    private Integer creditos;
    private String dias;
    private String asignatura;

    /**
     * Creates new form GruposAsig
     */
    public GruAsigBuscador(String usuario,String contrasena,String asi_codigo,String programa, String tipologia, Integer creditos, String dias,String asignatura) {
        initComponents();
        
        this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        BasicInternalFrameUI ui1 = (BasicInternalFrameUI) this.getUI();
        ui1.setNorthPane(null);
        this.conexion = cc.conexion(usuario,contrasena);
        
        this.asi_codigo = asi_codigo;
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.programa = programa;
        this.tipologia = tipologia;
        this.creditos= creditos;
        this.dias = dias;
        this.asignatura = asignatura;
        
        this.asig = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        
        asig.addColumn("Asignatura");
        asig.addColumn("Componente");
        asig.addColumn("Grupo");
        asig.addColumn("Cupos");
        asig.addColumn("Espacio");
        asig.addColumn("Profesor");
        
        asignaturas.setModel(asig);
        asignaturas.setFillsViewportHeight(true);
        
        this.pre = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        
        pre.addColumn("Prerrequisitos (Solo una asignatura de cada grupo)");

        
        Prerrequisito.setModel(pre);
        Prerrequisito.setFillsViewportHeight(true);
        
        try {
            String sql = "{CALL sp_buscador_cursos_por_asignatura(?,?)}";
            CallableStatement callableStatement = conexion.prepareCall(sql);

            // Establecer los parámetros de entrada del procedimiento   
            callableStatement.setString(1, this.asi_codigo);
            callableStatement.setString(2, this.programa);

            // Ejecutar el procedimiento almacenado
            boolean hasResults = callableStatement.execute();

            // Recorrer los resultados
            
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    String[] dato = new String[6];
                    while(resultSet.next()){
                        dato[0] = resultSet.getString("nombre");
                        dato[1] = resultSet.getString("componente");
                        dato[2] = resultSet.getString("grupo");
                        dato[3] = resultSet.getString("cupos");
                        dato[4] = resultSet.getString("espacio");
                        dato[5] = resultSet.getString("profesor");
                        asig.addRow(dato);
                    }  
                }
                
                // Verificar si hay más resultados disponibles
                hasResults = callableStatement.getMoreResults();
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    String[] prerreq = new String[1];
                    int i = 0;
                    int max;
                    while(resultSet.next()){
                        prerreq[0] = separadores(resultSet.getString("asignatura"));
                        max = countO(resultSet.getString("asignatura"),"//") + 1;
                        pre.addRow(prerreq);
                        Prerrequisito.setRowHeight(i, max*20);
                        i++;
                    }
                    
                    
                }
                
        } catch (SQLException ex) {
            Logger.getLogger(Historia.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    private String separadores(String descripción) {
        String convertido;
        String sinSaltos = descripción.replaceAll("//", "<br> ");
        convertido = "<HTML>" + sinSaltos + "</HTML>";
        return convertido;
    }
    
    public static int countO(String str, String ch) {

        Matcher matcher = Pattern.compile(String.valueOf(ch)).matcher(str);

        int counter = 0;
        while (matcher.find()) {
            counter++;
        }

        return counter;
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        Prerrequisito = new javax.swing.JTable();
        jButton1 = new javax.swing.JButton();
        titleLabel = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        asignaturas = new javax.swing.JTable();

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        Prerrequisito.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane1.setViewportView(Prerrequisito);

        jButton1.setBackground(new java.awt.Color(96, 25, 25));
        jButton1.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        jButton1.setForeground(new java.awt.Color(255, 255, 255));
        jButton1.setText("Volver");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton1MouseClicked(evt);
            }
        });
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        titleLabel.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        titleLabel.setText("Cita de inscripción/cancelación");

        asignaturas.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane2.setViewportView(asignaturas);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(525, 525, 525)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 171, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(101, 101, 101)
                        .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 552, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(0, 58, Short.MAX_VALUE)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 1120, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(42, 42, 42))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                    .addContainerGap(57, Short.MAX_VALUE)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 1120, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(43, 43, 43)))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(31, 31, 31)
                .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(486, 486, 486)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(28, 28, 28)
                .addComponent(jButton1)
                .addContainerGap(40, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(109, 109, 109)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 438, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(220, Short.MAX_VALUE)))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseClicked
        Buscador buscador_cursos = new Buscador(this.usuario,this.contrasena,this.programa,this.tipologia,this.creditos,this.dias,this.asignatura);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(buscador_cursos);
        buscador_cursos.setVisible(true);
    }//GEN-LAST:event_jButton1MouseClicked


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable Prerrequisito;
    private javax.swing.JTable asignaturas;
    private javax.swing.JButton jButton1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    public javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
}
