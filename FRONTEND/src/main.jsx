import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import React from 'react'
import './index.css'
import App from './App.jsx'
import StoreContextProvider from './context/StoreContext.jsx'
import { BrowserRouter, Routes, Route } from 'react-router-dom';


createRoot(document.getElementById('root')).render(
  <StrictMode>
  <BrowserRouter>
  <StoreContextProvider>
  <App/>
  </StoreContextProvider>
  </BrowserRouter>
  </StrictMode>,
)
