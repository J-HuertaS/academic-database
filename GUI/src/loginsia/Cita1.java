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
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.plaf.basic.BasicInternalFrameUI;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;
import static loginsia.SIA.Ventana;

/**
 *
 * @author HUERTAS
 */
public class Cita1 extends javax.swing.JInternalFrame {

    private DefaultTableModel inscripcion;
    private String programa;
    private String usuario;
    private String contrasena;
    SQLConnection cc = new SQLConnection();
    private Connection conexion;
    private ResultSet rs;


    public Cita1(String usuario,String contrasena, String programa) {
        initComponents();
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.programa = programa;
        this.conexion = cc.conexion(usuario,contrasena);
        
        this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        BasicInternalFrameUI ui1 = (BasicInternalFrameUI) this.getUI();
        ui1.setNorthPane(null);
        
        this.inscripcion = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
                
            }
        };
        inscripcion.addColumn("Asignatura");
        inscripcion.addColumn("Créditos");
        inscripcion.addColumn("Tipo");
        inscripcion.addColumn("Grupos disponibles");
        inscripcion.addColumn("Cupos disponibles");
        inscripcion.addColumn("Inscrita");
        Inscr.setModel(inscripcion);
        addCheckBox(5,Inscr);
        Inscr.setFillsViewportHeight(true);
        
        
        try {
            String sql = "{CALL sp_inscripcion_le(?,?)}";
            CallableStatement callableStatement = conexion.prepareCall(sql);
            callableStatement.setString(1,this.usuario);
            callableStatement.setString(2,this.programa);
            // Recorrer los resultados
            ResultSet resultSet = callableStatement.executeQuery();
            String[] datos = new String[5];
            int i = 0;
            while(resultSet.next()){
                datos[0] = resultSet.getString("asignatura");
                datos[1] = String.valueOf(resultSet.getInt("creditos"));
                datos[2] = resultSet.getString("tipo");
                datos[3] = resultSet.getString("grupos");
                datos[4] = resultSet.getString("cupos");
                inscripcion.addRow(datos);
                if ("0".equals(resultSet.getString("inscrito"))){
                    Inscr.setValueAt(true, i, 5);
                } else {
                    Inscr.setValueAt(false, i, 5);
                }
                i++;
                
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
        jScrollPane1 = new javax.swing.JScrollPane();
        Inscr = new javax.swing.JTable();
        titleLabel = new javax.swing.JLabel();
        sobrecupo = new javax.swing.JButton();

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        Inscr.setModel(new javax.swing.table.DefaultTableModel(
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
        Inscr.setGridColor(new java.awt.Color(255, 255, 255));
        Inscr.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                InscrMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(Inscr);

        titleLabel.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        titleLabel.setText("Cita de inscripción/cancelación");

        sobrecupo.setBackground(new java.awt.Color(96, 25, 25));
        sobrecupo.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        sobrecupo.setForeground(new java.awt.Color(255, 255, 255));
        sobrecupo.setText("Volver");
        sobrecupo.setActionCommand("");
        sobrecupo.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                sobrecupoMouseClicked(evt);
            }
        });
        sobrecupo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                sobrecupoActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(47, 47, 47)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 1120, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(101, 101, 101)
                        .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 552, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(41, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(sobrecupo, javax.swing.GroupLayout.PREFERRED_SIZE, 171, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(513, 513, 513))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(31, 31, 31)
                .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(26, 26, 26)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 548, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(34, 34, 34)
                .addComponent(sobrecupo)
                .addContainerGap(46, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void sobrecupoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_sobrecupoActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_sobrecupoActionPerformed

    private void InscrMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_InscrMouseClicked
        if (evt.getClickCount() == 2){
            String asignatura = String.valueOf(Inscr.getValueAt(Inscr.getSelectedRow(), 0));
            Pattern pattern = Pattern.compile("\\((.*?)\\)");
            Matcher matcher = pattern.matcher(asignatura);
            if (matcher.find()) {
                asignatura = matcher.group(1);
            } 
            System.out.println(asignatura);
            if("0".equals(String.valueOf(Inscr.getValueAt(Inscr.getSelectedRow(), 3)))){
                JOptionPane.showMessageDialog(null,"La asignatura no está siendo ofertada este semestre.");
            } else if ("0".equals(String.valueOf(Inscr.getValueAt(Inscr.getSelectedRow(), 4)))) {
                JOptionPane.showMessageDialog(null,"La asignatura no cuenta con cupos disponibles, puedes enviar un correo a la facultad que oferta la asignatura y solicitar un sobrecupo.");
            }  else {
                GruposAsig asig = new GruposAsig(this.usuario, this.contrasena, asignatura, programa);
                Ventana.removeAll();
                Ventana.updateUI();
                asig.titleLabel.setText("Inscripción/cancelación libre elección");
                Ventana.add(asig);
                asig.setVisible(true);
            }   
        }
    }//GEN-LAST:event_InscrMouseClicked

    private void sobrecupoMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_sobrecupoMouseClicked
        Cita0 volver = new Cita0(this.usuario,this.contrasena,this.programa);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(volver);
        volver.setVisible(true);
    }//GEN-LAST:event_sobrecupoMouseClicked


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable Inscr;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JButton sobrecupo;
    public javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
}
