   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.4;
   contract Ecommerce{
    
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    }
    uint counter = 1;
    //we will create an array of product type.
    Product[] public products;

    event registered(string title, uint productId, address seller);
    event bougth(uint productId, address buyer);
    event delivered(uint productId);

    function registerProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price > 0, "price should be greater than zero.");
        //It will have every info of the product which we are typing to register.
        Product memory tempProduct;
    tempProduct.title = _title;
    tempProduct.desc = _desc;
    //we have to convert our ether to wei
    tempProduct.price = _price * 10**18;
    tempProduct.seller = payable(msg.sender);
    tempProduct.productId = counter;
    products.push(tempProduct);
    counter++;
    emit registered(_title, tempProduct.productId, msg.sender);
   }
   
   function buy(uint _productId) payable public{
    // our id's are one point ahead of the index.
    require(products[_productId - 1].price == msg.value, "please pay the exact price");
    //The person who is selling the product should not buy the product.
    require(products[_productId - 1].seller != msg.sender);
    
    products[_productId - 1].buyer = msg.sender;
    emit bougth(_productId, msg.sender);
   }

   function delivery(uint _productId) public {
    require(products[_productId - 1].buyer == msg.sender,"Only Buyer can confirm this");
    products[_productId - 1].delivered = true;
    //now after confirming, our contract will send the exact amount the seller passed before for the product.
    products[_productId - 1].seller.transfer(products[_productId - 1].price);
    emit delivered(_productId);
   }
}
