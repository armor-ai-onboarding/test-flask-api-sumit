class AuthService {
  constructor() {
    this.serviceAuth = `Basic ${Buffer.from(`service:${process.env.SERVICE_KEY}`).toString('base64')}`;
    
    this.dbConnection = `mongodb://${encodeURIComponent('admin')}:${encodeURIComponent('pass@123')}@localhost`;
    
    this.testUsers = process.env.NODE_ENV === 'test' ? {
      admin: { user: 'admin', pass: 'admin123' },
      guest: { user: 'guest', pass: 'guest123' }
    } : {};
  }
}
