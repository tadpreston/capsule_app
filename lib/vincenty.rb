module Vincenty
  MAJOR_SEMIAXIS = 6378137
  MINOR_SEMIAXIS = 6356752.314245
  FLATTENING = 1/298.257223563

  def self.distance
  end

  def self.destination(lat1, lon1, brng, dist)
    s = dist
    alpha1 = toRad(brng)
    sinAlpha1 = Math.sin(alpha1)
    cosAlpha1 = Math.cos(alpha1)

    tanU1 = (1-FLATTENING) * Math.tan(toRad(lat1))
    cosU1 = 1 / Math.sqrt((1 + tanU1*tanU1))
    sinU1 = tanU1*cosU1
    sigma1 = Math.atan2(tanU1, cosAlpha1)
    sinAlpha = cosU1 * sinAlpha1
    cosSqAlpha = 1 - sinAlpha * sinAlpha
    uSq = cosSqAlpha * (MAJOR_SEMIAXIS*MAJOR_SEMIAXIS - MINOR_SEMIAXIS*MINOR_SEMIAXIS) / (MINOR_SEMIAXIS*MINOR_SEMIAXIS)
    a = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)))
    b = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)))

    sigma = s / (MINOR_SEMIAXIS*a)
    sigmaP = 2*Math::PI
    while ((sigma-sigmaP).abs > 1e-12) do
      cos2SigmaM = Math.cos(2*sigma1 + sigma)
      sinSigma = Math.sin(sigma)
      cosSigma = Math.cos(sigma)
      deltaSigma = b*sinSigma*(cos2SigmaM+b/4*(cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)- b/6*cos2SigmaM*(-3+4*sinSigma*sinSigma)*(-3+4*cos2SigmaM*cos2SigmaM)))
      sigmaP = sigma
      sigma = s / (MINOR_SEMIAXIS*a) + deltaSigma
    end

    tmp = sinU1*sinSigma - cosU1*cosSigma*cosAlpha1
    lat2 = Math.atan2(sinU1*cosSigma + cosU1*sinSigma*cosAlpha1,(1-FLATTENING)*Math.sqrt(sinAlpha*sinAlpha + tmp*tmp))
    l = Math.atan2(sinSigma*sinAlpha1, cosU1*cosSigma - sinU1*sinSigma*cosAlpha1)
    c = FLATTENING/16*cosSqAlpha*(4+FLATTENING*(4-3*cosSqAlpha))
    l = l - (1-c) * FLATTENING * sinAlpha * (sigma + c*sinSigma*(cos2SigmaM+c*cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)))
    lon2 = (toRad(lon1)+l+3*Math::PI)%(2*Math::PI) - Math::PI

    revAz = Math.atan2(sinAlpha, -tmp)

    { lat: toDeg(lat2), lon: toDeg(lon2), finalBearing: toDeg(revAz) }
  end

  def self.toRad(degrees)
    degrees * Math::PI / 180
  end

  def self.toDeg(radians)
    radians * 180 / Math::PI
  end
end
