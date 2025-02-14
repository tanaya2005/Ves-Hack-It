import { createContext } from "react";
import { livedons } from "../assets/livedons";
export const StoreContext = createContext(null)

//the CONTEXT APIs usage
const StoreContextProvider = (props) =>{

const contextValue = {
    // in this we can store any value or funct and can access in an y func using context
    livedons

}
return (
    <StoreContext.Provider value={contextValue}>
        {props.children}
    </StoreContext.Provider>
)

}

export default StoreContextProvider