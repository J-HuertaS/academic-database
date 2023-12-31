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
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.plaf.basic.BasicInternalFrameUI;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;
import static loginsia.SIA.Ventana;
import java.sql.SQLIntegrityConstraintViolationException;


/**
 *
 * @author HUERTAS
 */
public class GruposAsig extends javax.swing.JInternalFrame {

    private String asi_codigo;
    private String usuario;
    private String contrasena;
    private DefaultTableModel asig;
    SQLConnection cc = new SQLConnection();
    private Connection conexion;
    private String programa;

    /**
     * Creates new form GruposAsig
     */
    public GruposAsig(String usuario,String contrasena,String asi_codigo,String programa) {
        initComponents();
        
        this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        BasicInternalFrameUI ui1 = (BasicInternalFrameUI) this.getUI();
        ui1.setNorthPane(null);
        this.conexion = cc.conexion(usuario,contrasena);
        
        this.asi_codigo = asi_codigo;
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.programa = programa;
        
        this.asig = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return columnas == 3;
            }
        };
        
        asig.addColumn("Asignatura");
        asig.addColumn("Grupo");
        asig.addColumn("Grupos disponibles");
        asig.addColumn("Seleccionar");

        asignaturas.setModel(asig);
        addCheckBox(3,asignaturas);
        asignaturas.setFillsViewportHeight(true);
            try {
            String sql = "{CALL sp_grupos_por_asignatura(?,?,?)}";
            CallableStatement callableStatement = conexion.prepareCall(sql);

            // Establecer los parámetros de entrada del procedimiento  
            callableStatement.setString(1, this.usuario);

            callableStatement.setString(2, this.programa);
            
            callableStatement.setString(3, this.asi_codigo);

            // Ejecutar el procedimiento almacenado
            ResultSet rs = callableStatement.executeQuery();

            // Recorrer los resultados}
            if(rs.next()){
                String[] datos = new String[3];
                int i = 0;
                do {
                    datos[0] = rs.getString("asignatura");
                    datos[1] = String.valueOf(rs.getInt("grupo"));
                    datos[2] = String.valueOf(rs.getInt("cupos"));
                    asig.addRow(datos);
                    if(rs.getInt("inscrita") == 0){
                        asignaturas.setValueAt(true, i, 3);
                    }
                    i++;
                } while(rs.next());
            }
            
                
        } catch (SQLException ex) {
            Logger.getLogger(Historia.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        
    }
    
    private void addCheckBox(int column,JTable table){
        TableColumn tc = table.getColumnModel().getColumn(column);
        tc.setCellEditor(table.getDefaultEditor(Boolean.class));
        tc.setCellRenderer(table.getDefaultRenderer(Boolean.class));
    }
    
    private boolean isSelected(int row,int column,JTable table){
        Boolean s = Boolean.valueOf(String.valueOf(table.getValueAt(row, column)));
        return s == true;
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
        jButton1 = new javax.swing.JButton();
        titleLabel = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        asignaturas = new javax.swing.JTable();

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

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
        asignaturas.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                asignaturasMouseClicked(evt);
            }
        });
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
                        .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 995, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(124, Short.MAX_VALUE))
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
                .addGap(614, 614, 614)
                .addComponent(jButton1)
                .addContainerGap(40, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(109, 109, 109)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 540, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(118, Short.MAX_VALUE)))
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
        
        try {
            this.conexion = cc.conexion(usuario,contrasena);
            CallableStatement sp1 = conexion.prepareCall("{CALL sp_inscribir_asig(?,?,?,?,?)}");
            sp1.setString(1,this.usuario);
            sp1.setString(2, this.programa);
           sp1.setString(3, this.asi_codigo);
            int contador = 0;
            for(int i = 0; i < asignaturas.getRowCount(); i++){
                if(isSelected(i,3,asignaturas)){
                    contador++;
                }
            }
            if (contador > 1) {
                JOptionPane.showMessageDialog(null,"No puede inscribir varios grupos para la misma asignatura. Por favor, elija uno solo.");
            } else if (contador == 0){
                for(int i = 0; i < asignaturas.getRowCount(); i++){
                    sp1.setInt(4, Integer.parseInt(String.valueOf(asignaturas.getValueAt(i, 1))));
                    sp1.setBoolean(5,isSelected(i,3,asignaturas));
                    ResultSet rs = sp1.executeQuery();
                }   
                Cita0 inscripcion = new Cita0(this.usuario, this.contrasena, this.programa);
                volver();
            }else {
                for(int i = 0; i < asignaturas.getRowCount(); i++){
                    sp1.setInt(4, Integer.parseInt(String.valueOf(asignaturas.getValueAt(i, 1))));
                    sp1.setBoolean(5,isSelected(i,3,asignaturas));
                    ResultSet rs = sp1.executeQuery();
                } 
                volver();
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            JOptionPane.showMessageDialog(null,"Esto no está permitido, asegurate de no estar intentando inscribir más de un grupo.");
            JOptionPane.showMessageDialog(null,e);
            
        } catch (SQLException ex) {
            Logger.getLogger(GruposAsigSobreCupo.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null,ex);
        }
    }//GEN-LAST:event_jButton1MouseClicked

    private void asignaturasMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_asignaturasMouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_asignaturasMouseClicked

    private void volver(){
        if (titleLabel.getText().equals("Inscripción/cancelación")){
            Cita0 inscripcion = new Cita0(this.usuario, this.contrasena, this.programa);
            Ventana.removeAll();
            Ventana.updateUI();
            Ventana.add(inscripcion);
            inscripcion.setVisible(true);
        } else {
            Cita1 libre_eleccion = new Cita1(this.usuario, this.contrasena, this.programa);
            Ventana.removeAll();
            Ventana.updateUI();
            libre_eleccion.titleLabel.setText("Libre elección");
            Ventana.add(libre_eleccion);
            libre_eleccion.setVisible(true);
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable asignaturas;
    private javax.swing.JButton jButton1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane2;
    public javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
}
