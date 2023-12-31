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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.plaf.basic.BasicInternalFrameUI;

/**
 *
 * @author HUERTAS
 */
public class SeleccionCarrera extends javax.swing.JInternalFrame {

    
    private String usuario;
    private String contrasena;
    SQLConnection cc = new SQLConnection();
    private Connection conexion;
    /**
     * Creates new form SeleccionCarrera
     */
    public SeleccionCarrera(String usuario,String contrasena) {
        try {
            
            this.usuario = usuario;
            this.contrasena = contrasena;
            this.conexion = cc.conexion(usuario,contrasena);
            
            this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
            BasicInternalFrameUI ui = (BasicInternalFrameUI) this.getUI();
            ui.setNorthPane(null);
           
            initComponents();
            this.conexion = cc.conexion(usuario,contrasena);
            CallableStatement sp1 = conexion.prepareCall("{CALL sp_programas_est(?)}");
            sp1.setString(1, usuario);
            ResultSet rs = sp1.executeQuery();
            ArrayList<String> programas = new ArrayList<>();
            ProgramasBox.removeAllItems();
            while(rs.next()){
                programas.add(rs.getString("programa"));
            }
            for (int i = 0;i < programas.size(); i++){
                ProgramasBox.addItem(programas.get(i));
            }
        } catch (SQLException ex) {
            Logger.getLogger(SeleccionCarrera.class.getName()).log(Level.SEVERE, null, ex);
        }
        
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
        jLabel1 = new javax.swing.JLabel();
        titleLabel = new javax.swing.JLabel();
        ProgramasBox = new javax.swing.JComboBox<>();
        jButton1 = new javax.swing.JButton();

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jLabel1.setFont(new java.awt.Font("Arial", 0, 29)); // NOI18N
        jLabel1.setText("Plan de estudios");

        titleLabel.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        titleLabel.setText("jLabel1");

        ProgramasBox.setFont(new java.awt.Font("Arial", 0, 18)); // NOI18N
        ProgramasBox.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        ProgramasBox.setSelectedItem(null);

        jButton1.setBackground(new java.awt.Color(96, 25, 25));
        jButton1.setFont(new java.awt.Font("Arial", 1, 24)); // NOI18N
        jButton1.setForeground(new java.awt.Color(255, 255, 255));
        jButton1.setText("Siguiente");
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

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(44, 44, 44)
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 226, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(69, 69, 69)
                        .addComponent(ProgramasBox, javax.swing.GroupLayout.PREFERRED_SIZE, 767, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(461, 461, 461)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 213, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(129, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(97, 97, 97)
                    .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 552, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(586, Short.MAX_VALUE)))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(125, 125, 125)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(ProgramasBox, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(57, 57, 57)
                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(542, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(51, 51, 51)
                    .addComponent(titleLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(715, Short.MAX_VALUE)))
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

        if ("Historia Académica".equals(titleLabel.getText())) {
            SIA.Ventana.removeAll();
            SIA.Ventana.updateUI();
            Pattern pattern = Pattern.compile("\\((\\d+)\\)"); // Expresión regular para buscar números entre paréntesis
            Matcher matcher = pattern.matcher(ProgramasBox.getSelectedItem().toString());

            if (matcher.find()) {
                String coincidencia = matcher.group(1);
                Historia hist = new Historia(this.usuario,this.contrasena,coincidencia);
                SIA.Ventana.add(hist);
                hist.setVisible(true);
            }
            
        } else if ("Resumen de créditos".equals(titleLabel.getText())) {
            SIA.Ventana.removeAll();
            SIA.Ventana.updateUI();
            Pattern pattern = Pattern.compile("\\((.*?)\\)");
            Matcher matcher = pattern.matcher(ProgramasBox.getSelectedItem().toString());
            if (matcher.find()) {
                String coincidencia = matcher.group(1);
                ResCreditos creditos = new ResCreditos(this.usuario,this.contrasena,coincidencia);
                SIA.Ventana.add(creditos);
                creditos.setVisible(true);
            }
        } else if ("Cita de inscripción/cancelación".equals(titleLabel.getText())) {
            SIA.Ventana.removeAll();
            SIA.Ventana.updateUI();
            Pattern pattern = Pattern.compile("\\((\\d+)\\)"); // Expresión regular para buscar números entre paréntesis
            Matcher matcher = pattern.matcher(ProgramasBox.getSelectedItem().toString());
            if (matcher.find()) {
                String coincidencia = matcher.group(1);
                Cita0 ins_can = new Cita0(this.usuario,this.contrasena,coincidencia);
                SIA.Ventana.add(ins_can);
                ins_can.setVisible(true);
            }
        }
    }//GEN-LAST:event_jButton1MouseClicked

       
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> ProgramasBox;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    public javax.swing.JLabel titleLabel;
    // End of variables declaration//GEN-END:variables
}
