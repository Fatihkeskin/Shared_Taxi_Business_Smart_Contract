# Shared_Taxi_Business_Smart_Contract
to form a consensus between multiple users, enabling them to open a taxi business.

We first select an address and enter a value higher than 100 ether and add the address in the contract with the join key. 
If it is less than 100 ether, the given value returns an error.
This first appended address is assigned by constructor, as manager.
In the same way, other people are added to the contract with the join function.
By selecting the Manager's address, the address of the Car dealer is set with the Setcardealer button.
By selecting the address of the Car Dealer, the CarPropose button adds the necessary data.
Manager's address is selected, the car Dealer's money is sent with the Purchasecar button  if the offer valid time is not passed yet.
By selecting the address of the Car Dealer, the PurchasePropose button adds the necessary data.
By selecting the address of any participant, this participant may vote on the Proposed Purchase by Approvesellproposal button. Each participant can vote only once.
By selecting the car Dealer's address, the Sellcar button can be sell the car if the requirements of the modifier are confirmed.
Manager's address is selected and the driver's address is entered with the Setdriver button this function creates the driver (address).
By selecting any address and pressing the Getcharge button, the contract is sent from that person as a taxi fare (I defined it as 10 ether).
If the Manager's address is selected, the PaySalary button will release the money from the contract salary (once a month).
If the driver's address is selected, the ethers in the TaxiDriver_balance variable are transferred to the driver's address via the GetSalary button. 
If Manager's address is selected and the CarExpenses key is pressed, the Cardealer's address is sent to Fixed_expenses money (every 6 months).
If the Manager's address is selected, the shares of the participants are released (every 6 months) by pressing the Paydividend key.
Only participants are sent to the shared money addresses when they press the Getdividend key.
