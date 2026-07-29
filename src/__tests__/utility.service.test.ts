import { getUsageSummary } from '../modules/utilities/utility.service';

describe('getUsageSummary', () => {
  it('calculates consumed units and amount', () => {
    const reading = { previousReading: 100, currentReading: 150, unitPrice: 3000 };
    const result = getUsageSummary(reading);
    expect(result.consumed).toBe(50);
    expect(result.amount).toBe(150000);
  });

  it('handles zero consumption', () => {
    const reading = { previousReading: 100, currentReading: 100, unitPrice: 3000 };
    const result = getUsageSummary(reading);
    expect(result.consumed).toBe(0);
    expect(result.amount).toBe(0);
  });

  it('handles decimal values (string-like from Prisma Decimal)', () => {
    const reading = {
      previousReading: '1000.00',
      currentReading: '1010.50',
      unitPrice: '2500.0000',
    };
    const result = getUsageSummary(reading);
    expect(result.consumed).toBeCloseTo(10.5);
    expect(result.amount).toBeCloseTo(26250);
  });
});
