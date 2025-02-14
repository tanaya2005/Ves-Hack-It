import React from 'react'
import './displaydons.css'
import { useContext } from 'react'
import { StoreContext } from '../../context/StoreContext'


const displaydons = () => {
  const {livedons} = useContext(StoreContext)

  return (
    <div className='displaydons' id='displaydons'>
        <h2>Live Donations around you</h2>

    </div>
  )
}

export default displaydons