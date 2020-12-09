pragma solidity  ^0.6.0;
import "./ERC20Interface.sol";
import "./Math.sol";
import "./Staking.sol";
import "./Ownable.sol";


contract Token is ERC20Interface,Ownable
{
    using Math for uint256;
    
     
      function tokenname() public view returns (string memory) {
        return name;
    }

   
    function tokensymbol() public view returns (string memory) {
        return symbol;
    }
    
    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function transfer(address _to, uint _tokens)public  override returns(bool success)
    {
        require(balances[msg.sender] >=_tokens && _tokens>0);
        
            balances[msg.sender] = balances[msg.sender].sub(_tokens);
            balances[_to] =balances[_to].add(_tokens);
            emit  Transfer(msg.sender,_to,_tokens);
            return true;
            
        
      
        
    }
     function transferFrom(address _from,address __to, uint _token)public  override returns(bool success)
    {
            require(balances[_from] >=_token,"The spender should have enough tokens ");
            
        
            balances[_from]= balances[_from].sub(_token);
            balances[__to] =  balances[__to].add(_token);
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_token);
            
            emit Transfer(_from,__to,_token);
            return true;
            
       
    }
    
    function balanceOf(address _Owner) public override view returns (uint256 balance) {
        return balances[_Owner];
    }

    function approve(address _spender, uint256 _value)public override returns (bool success) {
        
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _tokenOwner, address _spenderaddr) public override view returns (uint256 remaining) {
      return allowed[_tokenOwner][_spenderaddr];
     }
    
    
     function mintToken(uint256 amount)external returns (bool)
    {
        totalSupply_ = totalSupply_.add(amount);
        
        balances[msg.sender] =balances[msg.sender].add( amount);
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }
      
   
     function _transferMintingOwnership(address _whom) internal {
        emit OwnershipTransferred(mintingOwner, _whom);
        mintingOwner = _whom;
    }
    
    
    function transferMintingOwnerShip(address _whom)
        external
        onlyOwner()
        returns (bool)
    {
        newMintingOwner = _whom;
        return true;
    }

    /**
     * @dev accept minting ownership
     */
   function acceptMintingOwnerShip() external returns (bool) {
        require(msg.sender == newMintingOwner, "ERR_ONLY_NEW_MINTING_OWNER");
        _transferMintingOwnership(newMintingOwner);
        newMintingOwner = address(0);
        return true;
    }
     
    
  
    mapping (address => uint256)public balances;
    mapping (address => mapping(address => uint256))allowed;
    
    
    constructor( ) public {
        balances[msg.sender] = _initialAmount;                               
    }
   
    string public  name="TEMP";
    string public  symbol="TEMPP" ;
    uint256 public decimals=18;
    uint256 public totalSupply_= 6000 * (uint256(10) ** decimals);
    
    uint256 public _initialAmount = totalSupply_ ;
    address public mintingOwner = msg.sender;
    address public newMintingOwner;
    
   
    
}