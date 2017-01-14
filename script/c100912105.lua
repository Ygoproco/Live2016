--真竜の継承
--True Draco Succession
--Script by nekrozar
function c100912105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912105,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100912105)
	e2:SetCondition(c100912105.drcon)
	e2:SetTarget(c100912105.drtg)
	e2:SetOperation(c100912105.drop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912105,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100912205)
	e3:SetTarget(c100912105.sumtg)
	e3:SetOperation(c100912105.sumop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912105,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,100912305)
	e4:SetCondition(c100912105.descon)
	e4:SetTarget(c100912105.destg)
	e4:SetOperation(c100912105.desop)
	c:RegisterEffect(e4)
	if c100912105.counter==nil then
		c100912105.counter=true
		c100912105[0]=0
		c100912105[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c100912105.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c100912105.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100912105.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) and (tc:IsSetCard(0x1f9) or tc:IsCode(30539496,34079868,82321037,87765315,96746083)) then
			local p=tc:GetReasonPlayer()
			local typ=bit.band(tc:GetOriginalType(),0x7)
			if (typ==TYPE_MONSTER and Duel.GetFlagEffect(p,100912105)==0)
				or (typ==TYPE_SPELL and Duel.GetFlagEffect(p,100912205)==0)
				or (typ==TYPE_TRAP and Duel.GetFlagEffect(p,100912305)==0) then
				c100912105[p]=c100912105[p]+1
				if typ==TYPE_MONSTER then
					Duel.RegisterFlagEffect(p,100912105,RESET_PHASE+PHASE_END,0,1)
				elseif typ==TYPE_SPELL then
					Duel.RegisterFlagEffect(p,100912205,RESET_PHASE+PHASE_END,0,1)
				else
					Duel.RegisterFlagEffect(p,100912305,RESET_PHASE+PHASE_END,0,1)
				end
			end
		end
		tc=eg:GetNext()
	end
end
function c100912105.clearop(e,tp,eg,ep,ev,re,r,rp)
	c100912105[0]=0
	c100912105[1]=0
end
function c100912105.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c100912105[tp]>0
end
function c100912105.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c100912105[tp]) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c100912105[tp])
end
function c100912105.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c100912105[tp],REASON_EFFECT)
end
function c100912105.sumfilter(c)
	return (c:IsSetCard(0x1f9) or c:IsCode(30539496,34079868,82321037,87765315,96746083)) and c:IsSummonable(true,nil,1)
end
function c100912105.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912105.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100912105.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c100912105.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c100912105.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c100912105.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912105.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end