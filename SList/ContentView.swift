//
///  ContentView.swift
//  MyShoppingList
//
//  Created by Gabriel Buchila on 25.08.2023.
//

import SwiftUI
 




var listItemsDictionary = [String : [ShoppItem]](); // hash table with all shoping ling items and as a key the name of the shoping list

//Global variable used to save created lists
let allShopListKey = "AllShopListKey"
let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AllShopList.json")

struct ContentView : View {
    @State var allShopList: [ShopList?] = [nil,] // All created shoping list
    @State var EditListsRefreshFlag = false // the  flag will trigger view refresh
    var body : some View {
        NavigationView(){
            VStack{
                // page header
                HStack{
                    logo()
                    
                    Spacer()
                    
                    newListButton(allShopList:$allShopList)
                    //editListsButton(EditListsRefreshFlag:EditListsRefreshFlag)
                    
                }
                .padding()
                
                Spacer()
                
                showAllCreatedList(allShopList:$allShopList)

                }
            }
        
        .onAppear {
            retriveAllListFromJson(&allShopList)
        }
      }
        
    }

//struct editListsButton {
//    fields
//}

struct newListCreation : View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var allShopList: [ShopList?]
    @State private var listName : String = ""
    
    var body : some View{
            Form {
                TextField("List Name", text: $listName)
                    .padding(0.5)
            }
        
        .navigationBarItems(trailing:
          HStack{
            Spacer()
            if(listName != ""){
                Button(action: {
                    allShopList.append(ShopList(name:listName))
                    saveAllListFromJson(shopListToSave:allShopList) //Save all list to JSon file
                    presentationMode.wrappedValue.dismiss()
                       }, label: {
                       Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .background( .white)
                        .foregroundColor(Color.green)
                        .cornerRadius(25)
                })
            }
        })
    }
}

/*
 Show all created List
 */
struct showAllCreatedList : View {
    @Binding var allShopList: [ShopList?]
    @State private var viewRefreshFlag = false // the flag flag will trigger view refresh
    var body: some View {
            VStack{
                ForEach(allShopList.compactMap { $0 }) { shopList in
                 ZStack {
                    NavigationLink(destination: showAndUpdateAllListElements(allShopList:$allShopList, shopListToEdit: Binding.constant(shopList)))
                    {
                        Text(shopList.name)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.green) // Set your desired background color
                            .foregroundColor(.white) // Set text color
                            .cornerRadius(10) // Set your desired corner radius
                        
                        Button(action: {
                            if let index = allShopList.firstIndex(where: { $0?.name == shopList.name} ) {
                                allShopList.remove(at: index)
                                saveAllListFromJson(shopListToSave:allShopList) //Save the updated list to JSon file
                                self.viewRefreshFlag.toggle()
                            }}){
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .cornerRadius(10)
                                    //.offset(x: 5, y: -20) // Adjust X and Y coordinates here
                            }
                    }
                    .padding([.leading, .trailing], 10)
                 }
                }
                Spacer()
            }
        
    }
}
/*
  View used to show/update/delete all elements inside a specific list
 */
struct showAndUpdateAllListElements : View {
    @Binding var allShopList: [ShopList?]
    @Binding var shopListToEdit: ShopList
    
    var body: some View{
            VStack{
                // page header
                HStack{
                    Spacer()
                    newListItemButton(allShopList:$allShopList,shopListToEdit:$shopListToEdit)
                }
                .padding()
                Spacer()

        }
    }
}

/*
 Button used to creat a new list item
 */
struct newListItemButton: View {
    @Binding var allShopList: [ShopList?]
    @Binding var shopListToEdit: ShopList
    @State private var viewRefreshFlag = false // the flag flag will trigger view refresh
    @State private var isCreatingNewItem = false // State to control the presentation of the new item creation view

    var body: some View {
        ForEach(shopListToEdit.allShoppItems) { shopitem in
            HStack {
                
                Text(String(shopitem.quantity) + " " + shopitem.itemName)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.green) // Set your desired background color
                    .foregroundColor(.white) // Set text color
                    .cornerRadius(10) // Set your desired corner radius
                
                Button(action: {
                    if let index = shopListToEdit.allShoppItems.firstIndex(where: { $0.itemName == shopitem.itemName} ) {
                        shopListToEdit.allShoppItems.remove(at: index)
                        saveAllListFromJson(shopListToSave:allShopList) //Save the updated list to JSon file
                        self.viewRefreshFlag.toggle()
                    }
                }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }
            }
                       
        }
            .navigationBarItems(trailing:
                HStack {
                    Spacer()
                    NavigationLink(destination: newListItemCreation(allShopList:$allShopList,shopListToEdit: $shopListToEdit),
                                   isActive: $isCreatingNewItem) {
                        EmptyView()
                    }
                    Button(action: {
                        // Set the flag to trigger NavigationLink
                        isCreatingNewItem = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .background(.white)
                            .foregroundColor(Color.green)
                            .cornerRadius(25)
                    }
                }
            )
    }
}

/*
 View used to define a new item and confirme it
 */
struct newListItemCreation : View {
    @Environment(\.presentationMode) var presentationMode
    @State private var ItemName : String = ""
    @State private var ItemQuantity : String = "1"
    @State private var newShoppItem : ShoppItem? = nil
    @Binding var allShopList: [ShopList?]
    @Binding var shopListToEdit: ShopList
    
    var body : some View{
        
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $ItemName)
                    .padding(0.5)
                
                TextField("Item Quantity", text: $ItemQuantity)
                    .padding(0.5)
                    .keyboardType(.numberPad)
            }
            
            .navigationBarItems(trailing:
             HStack{
                Spacer()
                Button(action: {
                    shopListToEdit.allShoppItems.append(ShoppItem(itemName:ItemName, quantity:ItemQuantity ))
                    saveAllListFromJson(shopListToSave:allShopList) //Save the updated list to JSon file
                    presentationMode.wrappedValue.dismiss()
                    
                //ToDo: save the new list item values
                    
                }, label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .background( .white)
                        .foregroundColor(Color.green)
                        .cornerRadius(25)
                })
            })
        }
        
    }
}



/*
 Create a view to create a new list
 */
struct newListButton : View{
    @Binding var allShopList: [ShopList?]
    
    var body: some View{
        NavigationLink (
            destination : newListCreation(allShopList:$allShopList),
            label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .background( .white)
                    .foregroundColor(Color.green)
                    .cornerRadius(25)
            }
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct logo : View{
    var body : some View{
            Image(systemName: "cart")
                .resizable()
                .frame(width: 20, height: 20,alignment: .center)
            
            Text("ShopList")
                .font(.system(size: 25, weight: .light, design: .default))
    }
}







