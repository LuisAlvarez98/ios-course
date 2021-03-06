//
//  TableViewController.swift
//  HW04
//
//  Created by Luis Felipe Alvarez Sanchez on 03/10/20.
//  Copyright © 2020 Luis Felipe Alvarez Sanchez. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
}

class TableViewController: UITableViewController {

    var listaArticulos : [Articulo] = []
    
    var articulo: Articulo!
    var editMode: Bool!
    var currIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         let app = UIApplication.shared
             
             NotificationCenter.default.addObserver(self, selector: #selector(guardarArticulos), name: UIApplication.didEnterBackgroundNotification, object: app)
             
             listaArticulos = []
             
             if FileManager.default.fileExists(atPath: urlArchivo().path){
                 obtenerArticulos()
             }
        title = "Articulos"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaArticulos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
        
          cell.lblId?.text = listaArticulos[indexPath.row].id
          cell.lblDesc?.text = listaArticulos[indexPath.row].descripcion
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "viewItem" {
                   let vistaDetalle = segue.destination as! ViewController
                 
                   let index = tableView.indexPathForSelectedRow!
                   vistaDetalle.articulo = listaArticulos[index.row]
                   vistaDetalle.currIndex = index.row
                   vistaDetalle.editMode = true
            
               }else{
                   let vistaAdd = segue.destination as! ViewController
                   vistaAdd.editMode = false
               }
              
    }
    
    @IBAction func unwindAdd(segue: UIStoryboardSegue){
        if editMode{
            listaArticulos[currIndex] = articulo
            tableView.reloadData()
        }else{
            if articulo != nil{
                listaArticulos.append(articulo)
                tableView.reloadData()
            }
        }
      }
    
    func urlArchivo() -> URL{
           let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
           let pathArchivo = url.appendingPathComponent("Empleados.plist")
           print(pathArchivo.path)
           
           return pathArchivo
       }
       
       @IBAction func guardarArticulos(){
           do{
               let data = try PropertyListEncoder().encode(listaArticulos)
               try data.write(to: urlArchivo())
           }catch{
               print("Error al guardar los datos")
           }
       }
       
       @IBAction func obtenerArticulos(){
           listaArticulos.removeAll()
           
           do{
               let data = try Data.init(contentsOf: urlArchivo())
               listaArticulos = try PropertyListDecoder().decode([Articulo].self, from:data)
           }catch{
               print("Error al cargar los datos")
           }
           tableView.reloadData()
       }
}
