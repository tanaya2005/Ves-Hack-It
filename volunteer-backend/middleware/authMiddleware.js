module.exports = (req, res, next) => {
    if (!req.session.volunteerId) {
      return res.status(401).json({ msg: 'Unauthorized, please login' });
    }
    next();
  };
  