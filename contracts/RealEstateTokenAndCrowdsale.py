import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st




load_dotenv()

w3= Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))


st.cache()
def load_contract():

    # Load the contract ABI
    with open(Path('compiled\RealEstateToken.json')) as f:
    
        RealEstateToken = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
        contract_address = os.getenv("TOKEN_SMART_CONTRACT_ADDRESS")
       
    # Get the contract
        contract= w3.eth.contract(
        address=contract_address,
        abi=RealEstateToken
    )

    return contract
contract = load_contract()

st.cache()
def load_crowdsale():
    with open(Path('compiled\RealEstateTokenCrowdsale.json')) as f:
        RealEstateTokenCrowdsale = json.load(f)
        crowdsale_address = os.getenv("CRS_SMART_CONTRACT_ADDRESS")

        crowdsale_contract = w3.eth.contract(
        address = crowdsale_address,
        abi = RealEstateTokenCrowdsale
    )
    
        return crowdsale_contract
crowdsale_contract = load_crowdsale() 


st.cache()
def load_crowdsale_deployer():
    with open(Path('compiled\RealEstateDeployer.json')) as f:
        crowdsale_dep_contract = json.load(f)
        crowdsale_deployer = os.getenv("Deployer_Address")


        crowdsale_dep_contract = w3.eth.contract(
        address = crowdsale_deployer, 
        abi = crowdsale_dep_contract
        )
    
        return crowdsale_dep_contract
crowdsale_dep_contract = load_crowdsale_deployer() 


st.write("Choose an account to get started")
accounts = w3.eth.accounts
address = st.selectbox("Select Account", options=accounts)
st.markdown("---")


################################################################################
# Register New RealEstate Asset
################################################################################

def asset_registration():
    st.title("Register Real Estate Asset")
    assetId = int(st.number_input("Asset ID"))
    assetName = str(st.text_input("Asset Name"))
    assetType = str(st.text_input("Asset Type"))
    location = str(st.text_input("Asset Location"))
    value = int(st.number_input("Asset Value"))
    listingURL = str(st.text_input("Listing URL"))
    if st.button("Submit"):
        tx_hash = contract.functions.registerRealEstateAsset(assetId, assetName,assetType,location, value, listingURL).transact({'from': address, 'gas':3000000 })
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Transaction Hash: {w3.toHex(tx_hash)}')
        st.write("Transaction receipt mined:")
        st.write(dict(receipt))
        st.write("Asset Registered")

def realeastate_token_crowdsale():  
    
    st.title("Real Estate Crowdsale")     
    rate = int(st.number_input("Rate"))
    wallet = address
    goal = int(st.number_input("Amount To Be Raised"))
    open =crowdsale_contract.functions.openingTime().call()
    close = crowdsale_contract.functions.closingTime().call()
    token = str(st.text_input("Token Symbol"))
    if st.button("Deploy Crowdsale"):
        tx_hash =crowdsale_contract.functions(rate, wallet, goal, open, close, token).transact({'from':address, 'gas':3000000})
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Transaction Hash:{w3.toHex(tx_hash)}')
        st.write("transaction receipt minded:")
        st.write(dict(receipt))
        st.write("Crowdsale Successfully Deployed")

def Investor_registration():
    st.title("Investor Registration")
    name = str(st.text_input("Name:"))
    lastName = str(st.text_input("Last Name:"))
    investorWallet = st.text_input("Investor Wallet Address:")
    if st.button("Register"):
        tx_hash = crowdsale_contract.functions.investorRegistration(name, lastName, investorWallet).transact({"from":address, "gas":3000000})
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Transaction Hash:{w3.toHex(tx_hash)}')
        st.write("transaction receipt minded:")
        st.write(dict(receipt))
        st.write("Investor Successfully Registered.")
   
#Buy tokens
def buyTokens():

    if crowdsale_contract.function.isOpen.call():
    
        if st.button("Buy Tokens"):
    #Calculate the number of tokens to buy
            buyTokens = st.number_input("Enter number of tokens you wish to buy")
    
    # Send a transaction to the contract
            tx_hash = crowdsale_contract.functions.buyTokens(address).transact({'from': address, 'value': buyTokens * 1})
            tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    
    #Check if the transaction was successful
            if tx_receipt['status'] == 1:
                st.write("Transaction successful!")
            else:
                st.write("Transaction failed!")
        else:
            st.write("Crowdsale not open or has ended.")

def main():
    st.title("Real Estate Token Management")

    menu = ["Home Page", "Register Real Estate Asset", "Asset Token Crowdsale", "Investor Registration", "Purchase Token"]
    choice = st.sidebar.selectbox("Select Your Option",options=menu)

    if choice == "Register Real Estate Asset":
        asset_registration()
    elif choice == "Asset Token Crowdsale":
        realeastate_token_crowdsale()
    elif choice == "Investor Registration":
        Investor_registration()
    elif choice == "Purchase Tokens":
        buyTokens()
    else:
        st.write("Welcome to Our Real Estate Tokenization Management dApp")
if __name__ == '__main__':
    main()




with st.sidebar:
    def crowdsale_parameters():
        st.title("Crowdsale Parameters")
        st.subheader("Please check parameters of crowdsale prior to token purchase")
    
    # Define a dictionary that maps each option in the select box to a function
    options = {
        "Goal": crowdsale_contract.functions.goal().call(),
        "Token Rate": crowdsale_contract.functions.rate().call(),
        "Token Address": crowdsale_contract.functions.token().call(),
        "Opening Time": crowdsale_contract.functions.isOpen().call(),
        "Closing Time": crowdsale_contract.functions.closingTime().call(),
        "Crowdsale Wallet": crowdsale_contract.functions.wallet().call(),
        "Amount of Wei Raised": crowdsale_contract.functions.weiRaised().call()
    }

    # Create the select box
    choice = st.selectbox("Select your option", options.keys())

    # Create a button to retrieve the selected parameter
    if st.button("Get Parameter"):
        parameter = options[choice]()
        st.write(f"{choice}: {parameter}")
    #crowdsale_parameters()
















