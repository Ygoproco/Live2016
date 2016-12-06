--真竜皇アグニマズドV
function c96746083.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,96746083)
	e1:SetTarget(c96746083.sptg)
	e1:SetOperation(c96746083.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,96746084)
	e2:SetCondition(c96746083.thcon)
	e2:SetTarget(c96746083.thtg)
	e2:SetOperation(c96746083.thop)
	c:RegisterEffect(e2)
end
function c96746083.desfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function c96746083.locfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c96746083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,100912046) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c96746083.desfilter,tp,loc,loc2,c)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=2 and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
		and (ft>0 or g:IsExists(c96746083.locfilter,-ft+1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c96746083.rmfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp)
end
function c96746083.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,100912046) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c96746083.desfilter,tp,loc,loc2,c)
	if g:GetCount()<2 or not g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) then return end
	local g1=nil local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft<1 then
		g1=g:FilterSelect(tp,c96746083.locfilter,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	g:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if g1:GetFirst():IsAttribute(ATTRIBUTE_FIRE) then
		g2=g:Select(tp,1,1,nil)
	else
		g2=g:FilterSelect(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_FIRE)
	end
	g1:Merge(g2)
	local rm=g1:IsExists(Card.IsAttribute,2,nil,ATTRIBUTE_FIRE)
	if Duel.Destroy(g1,REASON_EFFECT)==2 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SendtoGrave(c,REASON_RULE)
			return
		end
		local rg=Duel.GetMatchingGroup(c96746083.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,tp)
		if rm and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(96746083,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c96746083.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c96746083.thfilter(c)
	return c:GetAttribute()~=ATTRIBUTE_FIRE and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c96746083.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96746083.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c96746083.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96746083.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end