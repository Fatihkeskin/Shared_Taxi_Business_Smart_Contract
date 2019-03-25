pragma solidity >=0.4.22 <0.6.0;

contract Taxi_Dapp{

    uint256 public peopleCount = 0;
    mapping(uint => Participants) people;
    uint256 public chainStartTime = now;
    
    address payable this;
    
    address owner;
    address Manager;
    address payable public Car_Dealer ;
    uint256 Contract_balance = 0 ether;
    uint256 Fixed_expenses = 10 ether;
    uint256 Participation_fee = 100 ether;
    address payable TaxiDriver;
    uint TaxiDriver_balance = 0 ether;
    int32 Owned_Car;
    address payable public customer_of_taxi;
    uint256 charge = 10 ether; 
    uint256 salary = 20 ether;
    uint salary_time;
    uint sixMonthsControllerForExpenses;
    uint sixMonthsControllerForPay;
    uint public ApproveSellProposal_ = 0;
    
    address[] arr;
    
    modifier isOwner () {
        require(msg.sender == owner);
        _;
    }
     modifier isManager () {
        require(msg.sender == Manager);
        _;
    }
    modifier isCarDealer () {
        require(msg.sender == Car_Dealer);
        _;
    }
    modifier isParticipants(){
        address theaddres;
        for(uint i = 0; i<= peopleCount; i++){
                if(msg.sender == people[i].theAddress){
                    theaddres = msg.sender;
                }
        }
        require(msg.sender == theaddres);
        
        _;
    }
    
    modifier isntParticipants(){
        address theaddres2;
        for(uint i = 0; i<= peopleCount; i++){
            if(msg.sender == people[i].theAddress){
                theaddres2 = msg.sender;
            }
        }
        
        require(msg.sender != theaddres2);
        
        _;
    }
    modifier isPropasal_time () {
        require((Propose_Time + ProposedCar.offer_valid_time) > now);
        _;
    }
    modifier isPurchase_Propasal_time () {
        require((Purchase_Propose_Time + purchase_Propose.offer_valid_time) > now);
        _;
    }
    
    modifier isApproveSell (){
        require(ApproveSellProposal_ > (peopleCount/2));
        _;
    }
    
    modifier isTaxiDriver () {
        require(msg.sender == TaxiDriver);
        _;
    }
    
    modifier onceAMonth(){
        require(( now - salary_time ) > 2629746);
        _;
    }
    
    modifier onceSixMonthsEx (){
        require((sixMonthsControllerForExpenses + 15778476) < now);  // the number is for 6 months in seconds
        _;
        
    }
    
    modifier onceSixMonthsPar (){
        require((sixMonthsControllerForPay + 15778476) < now);  // the number is for 6 months in seconds
        _;
    }
    
    struct Participants {
        uint256 id;
        uint256 pay;
        uint256 thebalance;
        address payable theAddress;
        
    }
    struct Proposed_Car {
        int32 CarID;
        uint256 price;
        uint256 offer_valid_time;
        
    }
    Proposed_Car ProposedCar;
    
    struct Purchase_Propose{
        int32 CarID;
        uint256 price;
        uint256 offer_valid_time;
        bool approval_state;
    }
    Purchase_Propose purchase_Propose;
    
    constructor()public{
        owner = msg.sender; 
        Manager = owner;
    }

    
    
    function Join () public payable isntParticipants {     
        
        if(peopleCount < 100 && msg.value >= Participation_fee){  // if people count is less then 100 and the new member's money is enough for joining the contract  
            incrementCount();           // increment the people count
            uint256 balance = msg.sender.balance - Participation_fee;        // take the new members money
            uint256 zero = 0;
            people[peopleCount] = Participants(peopleCount, zero ,balance, msg.sender); // put the informations to peple struct
            Contract_balance = Contract_balance + Participation_fee;     // increase the contract balance by 100 ether
            this.transfer(Participation_fee);    // transfer the money
        }
        else{
            revert();
        }
       
    }
 

    function incrementCount()internal{      
        peopleCount ++;
    }
    
    
    function getBalanceOfTheContract() public view returns (uint256) {  // to display and control contract balance
        return this.balance - 2000 ether;
    }
  
    function SetCarDealer (address payable address_of_car_dealer) public isManager  {       // assign the car dealer (just for the manager)
        Car_Dealer = address_of_car_dealer;
    }
    
    uint256 Propose_Time;
    function CarPropose (int32 _CarID, uint256 _price, uint256 _offer_valid_time) public isCarDealer {  //offer_valid_time must be in seconds.
        ProposedCar.CarID = _CarID;
        ProposedCar.price = _price;
        ProposedCar.offer_valid_time = _offer_valid_time;  
        Propose_Time = now;
       
    }
    
    function PurchaseCar()public isManager isPropasal_time{
        Contract_balance = Contract_balance - ProposedCar.price;
        Car_Dealer.transfer(ProposedCar.price);
    }  
    
    uint256 Purchase_Propose_Time;
    function PurchasePropose (int32 _CarID, uint256 _price, uint256 _offer_valid_time, bool _approval_state) public isCarDealer {
        purchase_Propose.CarID = _CarID;
        purchase_Propose.price = _price;
        purchase_Propose.offer_valid_time = _offer_valid_time;
        purchase_Propose. approval_state = _approval_state;
        Purchase_Propose_Time = now;
       
    }

 
    uint public array_length = 0;
    function ApproveSellProposal() public isParticipants returns (bool){
        
        for(uint i = 0; i< peopleCount; i++){
                if(msg.sender == people[i].theAddress){
                    for(uint j = 0; j < arr.length; j++){
                        if(people[i].theAddress == arr[j]){
                            revert();
                            return false;
                        }
                    }
                    ApproveSellProposal_ = ApproveSellProposal_ + 1;
                    arr.push(people[i].theAddress);
                    array_length = arr.length;
                    return true;
                }
                
        }
      
    }
    
    function SellCar () public isCarDealer isApproveSell isPurchase_Propasal_time{
        Contract_balance = Contract_balance + purchase_Propose.price;
        this.transfer(purchase_Propose.price);
        ApproveSellProposal_ = 0;
        for(uint j = 0; j <arr.length; j++){
               delete arr[j];
        }
    }
    
    function SetDriver (address payable theTaxiDriver) isManager public {
        TaxiDriver = theTaxiDriver;
        salary_time = now;
    }
    
    function GetCharge() public {
        this.transfer(charge);
        Contract_balance = Contract_balance + charge;
        
    }
    
    function PaySalary () public isManager onceAMonth{ 
        Contract_balance = Contract_balance - salary;
        TaxiDriver_balance = TaxiDriver_balance + salary;
    }
    
    function GetSalary()public isTaxiDriver onceAMonth{
        TaxiDriver.transfer(TaxiDriver_balance);
    }
    
    function CarExpenses () public isManager onceSixMonthsEx{  
        Car_Dealer.transfer(Fixed_expenses);
        Contract_balance = Contract_balance - Fixed_expenses;
        sixMonthsControllerForExpenses = now;
        
        
    }
    function PayDividend()public isManager onceSixMonthsPar{ 
        uint pay_dividend = Contract_balance/peopleCount;
        for(uint i = 0; i< peopleCount; i++){
                people[i].pay = people[i].pay + pay_dividend;
        }
        sixMonthsControllerForPay = now;
    }
    function GetDividend() public payable isParticipants{
        uint pay_dividend = Contract_balance / peopleCount;
        for(uint i = 0; i< peopleCount; i++){
            if(msg.sender == people[i].theAddress){
                people[i].theAddress.transfer(pay_dividend);
                people[i].thebalance = people[i].thebalance + pay_dividend;  
            }
        }
    }
   
    function() payable external {
        revert();
    }
}
