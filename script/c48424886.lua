--エルシャドール・エグリスタ
function c48424886.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c48424886.fuscon)
	e1:SetOperation(c48424886.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c48424886.splimit)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48424886,0))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,48424886)
	e3:SetCondition(c48424886.condition)
	e3:SetTarget(c48424886.target)
	e3:SetOperation(c48424886.operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(48424886,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c48424886.thtg)
	e4:SetOperation(c48424886.thop)
	c:RegisterEffect(e4)
end
function c48424886.ffilter1(c)
	return (c:IsFusionSetCard(0x9d) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c48424886.ffilter2(c,fc)
	if c:IsHasEffect(6205579) then return false end
	if c:IsHasEffect(511002961) then return true end
	if Card.IsFusionAttribute then
		return (c:IsFusionAttribute(ATTRIBUTE_FIRE,fc) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
	else
		return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
	end
end
function c48424886.check1(c,mg,sg,chkf)
	local g=mg:Clone()
	if sg:IsContains(c) then g:Sub(sg) end
	return g:IsExists(c48424886.check2,1,c,c,chkf)
end
function c48424886.check2(c,c2,chkf)
	local g=Group.FromCards(c,c2)
	if g:IsExists(aux.TuneMagFusFilter,1,nil,g,chkf) then return false end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if c48424886.ffilter1(tc) or tc:IsHasEffect(511002961) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if c48424886.ffilter2(tc) or tc:IsHasEffect(511002961) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2c,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2c,1,nil,g2) end
end
function c48424886.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c48424886.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		sg=Duel.GetMatchingGroup(c48424886.exfilter,tp,0,LOCATION_MZONE,nil,g)
		mg:Merge(sg)
	end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return c48424886.check1(gc,mg,sg,chkf)
	end
	return mg:IsExists(c48424886.check1,1,nil,mg,sg,chkf)
end
function c48424886.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local c=e:GetHandler()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local p=tp
	local sfhchk=false
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c48424886.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,c48424886.check2,1,1,gc,gc,chkf)
		local tc1=g1:GetFirst()
		if c48424886.exfilter(tc1,eg) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		end
		if sfhchk then Duel.ShuffleHand(tp) end
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(p,c48424886.check1,1,1,nil,mg,exg,chkf)
	local tc1=g1:GetFirst()
	if c48424886.exfilter(tc1,eg) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		mg:Sub(exg)
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(p,c48424886.check2,1,1,tc1,tc1,chkf)
	if c48424886.exfilter(g2:GetFirst(),eg) then fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
	g1:Merge(g2)
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end
function c48424886.FConditionFilterF2c(c,f1,f2,fc)
	return f1(c) or f2(c,fc)
end
function c48424886.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c48424886.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c48424886.filter(c)
	return c:IsSetCard(0x9d)
end
function c48424886.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48424886.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c48424886.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c48424886.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c48424886.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c48424886.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c48424886.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c48424886.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c48424886.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c48424886.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
