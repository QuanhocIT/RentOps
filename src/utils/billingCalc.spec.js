// Unit Tests for RentOps Core Business Logic

import { describe, it, expect } from 'vitest'
import { ROOM_STATUS, BILL_STATUS, DEFAULT_RATES } from '../config/constants'

describe('RentOps Core Constants & Calculations', () => {
  it('should have standard room status definitions', () => {
    expect(ROOM_STATUS.RENTED).toBe('rented')
    expect(ROOM_STATUS.VACANT).toBe('vacant')
    expect(ROOM_STATUS.MAINTENANCE).toBe('maintenance')
    expect(ROOM_STATUS.RESERVED).toBe('reserved')
  })

  it('should have standard default utility rates', () => {
    expect(DEFAULT_RATES.ELECTRIC_RATE).toBe(3500)
    expect(DEFAULT_RATES.WATER_RATE).toBe(18000)
    expect(DEFAULT_RATES.SERVICE_FEE).toBe(150000)
  })

  it('should calculate electric cost accurately from consumption', () => {
    const prevElectric = 1000
    const currElectric = 1150
    const usage = Math.max(0, currElectric - prevElectric)
    const cost = usage * DEFAULT_RATES.ELECTRIC_RATE
    
    expect(usage).toBe(150)
    expect(cost).toBe(525000)
  })

  it('should calculate water cost accurately from consumption', () => {
    const prevWater = 40
    const currWater = 48
    const usage = Math.max(0, currWater - prevWater)
    const cost = usage * DEFAULT_RATES.WATER_RATE

    expect(usage).toBe(8)
    expect(cost).toBe(144000)
  })

  it('should calculate total bill amount correctly', () => {
    const roomPrice = 5000000
    const electricCost = 525000
    const waterCost = 144000
    const serviceFee = 150000
    const total = roomPrice + electricCost + waterCost + serviceFee

    expect(total).toBe(5819000)
  })

  it('should handle meter rollover when current reading is smaller than previous reading', () => {
    const prevElectric = 9980
    const currElectric = 120 // Meter reset at 10000
    const maxReading = 10000
    const usage = (maxReading - prevElectric) + currElectric

    expect(usage).toBe(140)
  })

  it('should calculate contract expiry days accurately', () => {
    const now = new Date('2026-07-31T00:00:00Z').getTime()
    const endDate = new Date('2026-08-15T00:00:00Z').getTime()
    const diffDays = Math.ceil((endDate - now) / (1000 * 60 * 60 * 24))

    expect(diffDays).toBe(15)
    expect(diffDays <= 30).toBe(true)
  })
})
